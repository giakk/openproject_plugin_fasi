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

interface FaseAData {
  project_id: number;
  sconto_fattura?: string;
  data_inizio_lavori?: string;
  data_fine_lavori?: string;
  finiture_estetiche?: string;
  rilievi_definitivi?: string;
  copia_chiavi?: string;
  sopralluogo?: string;
  autorizzazione_comunale?: string;
  ordine_struttura?: string;
  consegna_struttura?: string;
  ordine_materiale?: string;
  consegna_materiale?: string;
  ordine_montaggio?: string;
  ordine_opere?: string;
  ponteggio?: string;
  ordine_serramenti?: string;
  ordine_lavorazioni?: string;
  spostamento_tubazioni?: string;
  disegno_definitivo?: string;
  dichiarazione_strutture?: string;
  dichiarazione_assorbimenti?: string;
  schema_elettrico?: string;
  ampliamento_contatore?: string;
  approvazione_disegno_cliente?: string;
}

@Component({
  selector: 'fase-a-data',
  templateUrl: './fase-a-data.component.html',
  styleUrls: ['./fase-a-data.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: false,
})
export class FaseADataComponent implements OnInit {
  public data: FaseAData | null = null;
  public loading = true;
  public saving = false;
  public projectId: string;

  public fields = [
    { key: 'sconto_fattura', label: 'fase_a.sconto_fattura' },
    { key: 'data_inizio_lavori', label: 'fase_a.data_inizio_lavori' },
    { key: 'data_fine_lavori', label: 'fase_a.data_fine_lavori' },
    { key: 'finiture_estetiche', label: 'fase_a.finiture_estetiche' },
    { key: 'rilievi_definitivi', label: 'fase_a.rilievi_definitivi' },
    { key: 'copia_chiavi', label: 'fase_a.copia_chiavi' },
    { key: 'sopralluogo', label: 'fase_a.sopralluogo' },
    { key: 'autorizzazione_comunale', label: 'fase_a.autorizzazione_comunale' },
    { key: 'ordine_struttura', label: 'fase_a.ordine_struttura' },
    { key: 'consegna_struttura', label: 'fase_a.consegna_struttura' },
    { key: 'ordine_materiale', label: 'fase_a.ordine_materiale' },
    { key: 'consegna_materiale', label: 'fase_a.consegna_materiale' },
    { key: 'ordine_montaggio', label: 'fase_a.ordine_montaggio' },
    { key: 'ordine_opere', label: 'fase_a.ordine_opere' },
    { key: 'ponteggio', label: 'fase_a.ponteggio' },
    { key: 'ordine_serramenti', label: 'fase_a.ordine_serramenti' },
    { key: 'ordine_lavorazioni', label: 'fase_a.ordine_lavorazioni' },
    { key: 'spostamento_tubazioni', label: 'fase_a.spostamento_tubazioni' },
    { key: 'disegno_definitivo', label: 'fase_a.disegno_definitivo' },
    { key: 'dichiarazione_strutture', label: 'fase_a.dichiarazione_strutture' },
    { key: 'dichiarazione_assorbimenti', label: 'fase_a.dichiarazione_assorbimenti' },
    { key: 'schema_elettrico', label: 'fase_a.schema_elettrico' },
    { key: 'ampliamento_contatore', label: 'fase_a.ampliamento_contatore' },
    { key: 'approvazione_disegno_cliente', label: 'fase_a.approvazione_disegno_cliente' },
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
    console.log('FaseADataComponent ngOnInit chiamato');
    this.loadData();
  }

  private loadData(): void {
    this.loading = true;
    const url = `/projects/${this.projectId}/fase_a_data`;

    this.http.get<FaseAData>(url, { observe: 'response' }).subscribe({
      next: (response) => {
        this.data = response.body;
        this.loading = false;
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error loading Fase A data:', error);
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
    const url = `/projects/${this.projectId}/fase_a_data`;

    const payload = {
      sconto_fattura: this.data.sconto_fattura,
      data_inizio_lavori: this.data.data_inizio_lavori,
      data_fine_lavori: this.data.data_fine_lavori,
      finiture_estetiche: this.data.finiture_estetiche,
      rilievi_definitivi: this.data.rilievi_definitivi,
      copia_chiavi: this.data.copia_chiavi,
      sopralluogo: this.data.sopralluogo,
      autorizzazione_comunale: this.data.autorizzazione_comunale,
      ordine_struttura: this.data.ordine_struttura,
      consegna_struttura: this.data.consegna_struttura,
      ordine_materiale: this.data.ordine_materiale,
      consegna_materiale: this.data.consegna_materiale,
      ordine_montaggio: this.data.ordine_montaggio,
      ordine_opere: this.data.ordine_opere,
      ponteggio: this.data.ponteggio,
      ordine_serramenti: this.data.ordine_serramenti,
      ordine_lavorazioni: this.data.ordine_lavorazioni,
      spostamento_tubazioni: this.data.spostamento_tubazioni,
      disegno_definitivo: this.data.disegno_definitivo,
      dichiarazione_strutture: this.data.dichiarazione_strutture,
      dichiarazione_assorbimenti: this.data.dichiarazione_assorbimenti,
      schema_elettrico: this.data.schema_elettrico,
      ampliamento_contatore: this.data.ampliamento_contatore,
      approvazione_disegno_cliente: this.data.approvazione_disegno_cliente,
    };

    this.http.put<FaseAData>(url, { fase_a_datum: payload }, { observe: 'response' }).subscribe({
      next: (response) => {
        this.data = response.body;
        this.saving = false;
        this.toastService.addSuccess(this.i18n.t('js.fase_a.saved_successfully'));
        this.cdRef.detectChanges();
      },
      error: (error) => {
        console.error('Error saving Fase A data:', error);
        this.saving = false;
        this.toastService.addError(this.i18n.t('js.fase_a.save_error'));
        this.cdRef.detectChanges();
      },
    });
  }

  public getText(key: string): string {
    return this.i18n.t(`js.${key}`);
  }
}