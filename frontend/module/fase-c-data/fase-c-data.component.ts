import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  OnInit,
} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';

interface FaseCData {
  project_id: number;
  collaudo_impianto?: string;
  libretto_impianto?: string;
  dichiarazione_ce?: string;
  contratto_manutenzione?: string;
  incarico_ente_certificato?: string;
  numero_matricola?: string;
  fine_lavori_pratica?: string;
  variazione_catastale?: string;
  hide?: boolean;
  can_edit: boolean;
}

@Component({
  selector: 'fase-c-data',
  templateUrl: './fase-c-data.component.html',
  styleUrls: ['./fase-c-data.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: false,
})
export class FaseCDataComponent implements OnInit {
  public data: FaseCData | null = null;
  public loading = true;
  public saving = false;
  public projectId: string;

  public fields = [
    { key: 'collaudo_impianto', label: 'fase_c.collaudo_impianto' },
    { key: 'libretto_impianto', label: 'fase_c.libretto_impianto' },
    { key: 'dichiarazione_ce', label: 'fase_c.dichiarazione_ce' },
    { key: 'contratto_manutenzione', label: 'fase_c.contratto_manutenzione' },
    { key: 'incarico_ente_certificato', label: 'fase_c.incarico_ente_certificato' },
    { key: 'numero_matricola', label: 'fase_c.numero_matricola' },
    { key: 'fine_lavori_pratica', label: 'fase_c.fine_lavori_pratica' },
    { key: 'variazione_catastale', label: 'fase_c.variazione_catastale' },
  ];

  constructor(
    private http: HttpClient,
    private i18n: I18nService,
    private toastService: ToastService,
    private currentProject: CurrentProjectService,
    private cdRef: ChangeDetectorRef,
  ) {
    this.projectId = this.currentProject.id || '';
  }

  ngOnInit(): void {
    console.log('FaseCDataComponent ngOnInit chiamato');
    this.loadData();
  }

  private loadData(): void {
    this.loading = true;
    const url = `/projects/${this.projectId}/fase_c_data`;

    this.http.get<FaseCData>(url, { observe: 'response' }).subscribe({
      next: (response) => {
        console.log('Response completa:', response);
        console.log('Status:', response.status);
        console.log('Body:', response.body);
        
        this.data = response.body;
        this.loading = false;
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error loading Fase C data:', error);
        this.loading = false;
        this.cdRef.detectChanges();
      },
    });
  }

  public save(): void {
    if (!this.data || this.saving) {
      return;
    }

    this.saving = true;
    const url = `/projects/${this.projectId}/fase_c_data`;

    const payload = {
      collaudo_impianto: this.data.collaudo_impianto,
      libretto_impianto: this.data.libretto_impianto,
      dichiarazione_ce: this.data.dichiarazione_ce,
      contratto_manutenzione: this.data.contratto_manutenzione,
      incarico_ente_certificato: this.data.incarico_ente_certificato,
      numero_matricola: this.data.numero_matricola,
      fine_lavori_pratica: this.data.fine_lavori_pratica,
      variazione_catastale: this.data.variazione_catastale
    };

    this.http.put<FaseCData>(url, { fase_c_datum: payload }, { observe: 'response' }).subscribe({
      next: (response) => {
        console.log('=== SAVE RESPONSE:', response);
        this.data = response.body;
        this.saving = false;
        this.toastService.addSuccess(this.i18n.t('js.fase_c.saved_successfully'));
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error saving Fase C data:', error);
        this.saving = false;
        this.toastService.addError(this.i18n.t('js.fase_c.save_error'));
        this.cdRef.detectChanges();
      },
    });
  }

  public canEdit(): boolean {
    return this.data?.can_edit || false;
  }

  public getText(key: string): string {
    return this.i18n.t(`js.${key}`);
  }

  public toggleHide(event: Event): void {
    const checkbox = event.target as HTMLInputElement;
    const newHideValue = checkbox.checked;

    if (!this.data) {
      return;
    }

    const url = `/projects/${this.projectId}/fase_c_data`;
    const payload = {
      hide: newHideValue,
    };

    this.http.put<FaseCData>(url, { fase_c_datum: payload }, { observe: 'response' }).subscribe({
      next: (response) => {
        if (this.data && response.body) {
          this.data.hide = response.body.hide;
        }
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error updating hide status:', error);
        if (this.data) {
          this.data.hide = !newHideValue;
          checkbox.checked = !newHideValue;
        }
        this.cdRef.detectChanges();
      },
    });
  }
}