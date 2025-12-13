import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  OnInit,
} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';

interface PhaseColumn {
  key: string;
  label: string;
}

interface PhaseData {
  [key: string]: string | boolean | undefined;
  hide?: boolean;
}

interface ProjectPhaseData {
  project_id: number;
  project_name: string;
  project_identifier: string;
  indirizzo_impianto: string | null;
  fase_a: PhaseData;
  fase_b: PhaseData;
  fase_c: PhaseData;
}

interface OverviewData {
  projects: ProjectPhaseData[];
  columns: {
    fase_a: PhaseColumn[];
    fase_b: PhaseColumn[];
    fase_c: PhaseColumn[];
  };
}

@Component({
  selector: 'phases-overview',
  templateUrl: './phases-overview.component.html',
  styleUrls: ['./phases-overview.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: false,
})
export class PhasesOverviewComponent implements OnInit {
  public data: OverviewData | null = null;
  public filteredProjects: ProjectPhaseData[] = [];
  public loading = true;
  public searchTerm = '';
  public editingCell: { projectId: number; phase: string; field: string } | null = null;
  public tempValue = '';

  // Tab attivo
  public activeTab: 'fase_a' | 'fase_b' | 'fase_c' = 'fase_a';

  // Stato di espansione delle fasi (mantenuto per retrocompatibilità)
  public collapsedPhases: { [key: string]: boolean } = {
    fase_a: false,
    fase_b: false,
    fase_c: false,
  };

  constructor(
    private http: HttpClient,
    private i18n: I18nService,
    private toastService: ToastService,
    private cdRef: ChangeDetectorRef,
  ) {}

  ngOnInit(): void {
    console.log('Phases Overview ngOnInit chiamato');
    this.loadData();
  }

  private loadData(): void {
    this.loading = true;
    const url = '/phases_overview';

    this.http.get<OverviewData>(url, { observe: 'response' }).subscribe({
      next: (response) => {
        this.data = response.body;
        this.applyFilters();
        this.loading = false;
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error loading phases overview:', error);
        this.loading = false;
        this.toastService.addError(this.i18n.t('js.phases_overview.load_error'));
        this.cdRef.detectChanges();
      },
    });
  }

  public onSearch(): void {
    this.applyFilters();
  }

  public setActiveTab(tab: 'fase_a' | 'fase_b' | 'fase_c'): void {
    this.activeTab = tab;
    this.applyFilters();
  }

  private applyFilters(): void {
    if (!this.data) return;

    let filtered = this.data.projects;

    // Filtra per hide status in base al tab attivo
    filtered = filtered.filter(project => {
      const phaseData = project[this.activeTab as keyof ProjectPhaseData] as PhaseData;
      return !phaseData?.hide;
    });

    // Filtra per search term
    const term = this.searchTerm.toLowerCase().trim();
    if (term !== '') {
      filtered = filtered.filter(project =>
        project.project_name.toLowerCase().includes(term) ||
        project.project_identifier.toLowerCase().includes(term) ||
        (project.indirizzo_impianto && project.indirizzo_impianto.toLowerCase().includes(term))
      );
    }

    this.filteredProjects = filtered;
    this.cdRef.detectChanges();
  }

  public togglePhase(phase: string): void {
    this.collapsedPhases[phase] = !this.collapsedPhases[phase];
    this.cdRef.detectChanges();
  }

  public isPhaseCollapsed(phase: string): boolean {
    return this.collapsedPhases[phase] || false;
  }

  public startEditing(projectId: number, phase: string, field: string, currentValue: string | undefined): void {
    this.editingCell = { projectId, phase, field };
    this.tempValue = currentValue || '';
    this.cdRef.detectChanges();
  }

  public cancelEditing(): void {
    this.editingCell = null;
    this.tempValue = '';
    this.cdRef.detectChanges();
  }

  public saveCell(projectId: number, phase: string, field: string): void {
    const url = '/phases_overview/update';

    const payload = {
      project_id: projectId,
      phase_type: phase,
      field_name: field,
      value: this.tempValue,
    };

    this.http.put(url, payload, { observe: 'response' }).subscribe({
      next: (response: any) => {
        // Aggiorna il valore locale nel data originale (non in filteredProjects)
        const project = this.data?.projects.find(p => p.project_id === projectId);
        if (project && project[phase as keyof ProjectPhaseData]) {
          (project[phase as keyof ProjectPhaseData] as PhaseData)[field] = this.tempValue;
        }

        this.editingCell = null;
        this.tempValue = '';
        this.toastService.addSuccess(this.i18n.t('js.phases_overview.saved_successfully'));
        this.applyFilters();
      },
      error: (error) => {
        console.error('Error saving cell:', error);
        this.toastService.addError(this.i18n.t('js.phases_overview.save_error'));
        this.cancelEditing();
      },
    });
  }

  public isEditing(projectId: number, phase: string, field: string): boolean {
    return this.editingCell?.projectId === projectId &&
           this.editingCell?.phase === phase &&
           this.editingCell?.field === field;
  }

  public getProjectUrl(identifier: string): string {
    return `/projects/${identifier}`;
  }

  public getText(key: string): string {
    return this.i18n.t(`js.${key}`);
  }

  public getCellValue(project: ProjectPhaseData, phase: string, field: string): string {
    const phaseData = project[phase as keyof ProjectPhaseData] as PhaseData;
    const value = phaseData?.[field];

    if (value === undefined || value === null) {
      return '';
    }

    if (typeof value === 'boolean') {
      return value.toString();
    }

    return value;
  }

  public trackByProjectId(index: number, project: ProjectPhaseData): number {
    return project.project_id;
  }

  public trackByColumnKey(index: number, column: PhaseColumn): string {
    return column.key;
  }
}
