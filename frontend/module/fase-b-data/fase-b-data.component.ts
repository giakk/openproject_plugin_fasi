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

interface FaseBData {
  project_id: number;
  fossa_ridotta?: string;
  notifica_asl?: string;
  coordinamento_sicurezza?: string;
  cartello_di_cantiere?: string;
  autorizzazione_subappalto?: string;
  consegna_doc_sicurezza?: string;
  prove_materiali?: string;
  consegna_cliente?: string;
  verbale_consegna?: string;
}

@Component({
  selector: 'fase-b-data',
  templateUrl: './fase-b-data.component.html',
  styleUrls: ['./fase-b-data.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: false,
})
export class FaseBDataComponent implements OnInit {
  public data: FaseBData | null = null;
  public loading = true;
  public saving = false;
  public projectId: string;

  public fields = [
    { key: 'fossa_ridotta', label: 'fase_b.fossa_ridotta' },
    { key: 'notifica_asl', label: 'fase_b.notifica_asl' },
    { key: 'coordinamento_sicurezza', label: 'fase_b.coordinamento_sicurezza' },
    { key: 'cartello_di_cantiere', label: 'fase_b.cartello_di_cantiere' },
    { key: 'autorizzazione_subappalto', label: 'fase_b.autorizzazione_subappalto' },
    { key: 'consegna_doc_sicurezza', label: 'fase_b.consegna_doc_sicurezza' },
    { key: 'prove_materiali', label: 'fase_b.prove_materiali' },
    { key: 'consegna_cliente', label: 'fase_b.consegna_cliente' },
    { key: 'verbale_consegna', label: 'fase_b.verbale_consegna' },
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
    console.log('FaseBDataComponent ngOnInit chiamato');
    this.loadData();
  }

  private loadData(): void {
    this.loading = true;
    const url = `/projects/${this.projectId}/fase_b_data`;

    this.http.get<FaseBData>(url, { observe: 'response' }).subscribe({
      next: (response) => {    
        this.data = response.body;
        this.loading = false;
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error saving Fase B data:', error);        
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
    const url = `/projects/${this.projectId}/fase_b_data`;

    const payload = {
      fossa_ridotta: this.data.fossa_ridotta,
      notifica_asl: this.data.notifica_asl,
      coordinamento_sicurezza: this.data.coordinamento_sicurezza,
      cartello_di_cantiere: this.data.cartello_di_cantiere,
      autorizzazione_subappalto: this.data.autorizzazione_subappalto,
      consegna_doc_sicurezza: this.data.consegna_doc_sicurezza,
      prove_materiali: this.data.prove_materiali,
      consegna_cliente: this.data.consegna_cliente,
      verbale_consegna: this.data.verbale_consegna
    };

    this.http.put<FaseBData>(url, { fase_b_datum: payload }, { observe: 'response' }).subscribe({
      next: (response) => {
        this.data = response.body;
        this.saving = false;
        this.toastService.addSuccess(this.i18n.t('js.fase_b.saved_successfully'));
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error saving Fase B data:', error);
        this.saving = false;
        this.toastService.addError(this.i18n.t('js.fase_b.save_error'));
        this.cdRef.detectChanges();
      },
    });
  }

  public getText(key: string): string {
    return this.i18n.t(`js.${key}`);
  }
}