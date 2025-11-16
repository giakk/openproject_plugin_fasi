import { CommonModule } from '@angular/common';
import { FaseADataComponent } from './fase-a-data/fase-a-data.component';
import { FaseBDataComponent } from './fase-b-data/fase-b-data.component';
import { FaseCDataComponent } from './fase-c-data/fase-c-data.component';
import { PhasesOverviewComponent } from './fase-overview/phases-overview.component';
import { registerCustomElement } from 'core-app/shared/helpers/angular/custom-elements.helper';
import { FormsModule } from '@angular/forms';
import { Injector, NgModule,} from '@angular/core';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
  ],
  declarations: [
    FaseADataComponent,
    FaseBDataComponent,
    FaseCDataComponent,
    PhasesOverviewComponent,
  ],
})
export class PluginModule {
  constructor(injector: Injector) {
    console.log('Phases Plugin initialized');
    registerCustomElement('fase-a-data', FaseADataComponent, { injector });
    registerCustomElement('fase-b-data', FaseBDataComponent, { injector });
    registerCustomElement('fase-c-data', FaseCDataComponent, { injector });
    registerCustomElement('phases-overview', PhasesOverviewComponent, { injector });
  }
}