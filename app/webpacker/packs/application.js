require.context('govuk-frontend/govuk/assets');

import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { initAll } from 'govuk-frontend';
import { autocompleteSelection } from "./autocomplete.js";

Rails.start();
Turbolinks.start();
initAll();

document.addEventListener('turbolinks:load', () => {
  autocompleteSelection('#autocomplete_trusts', '/trusts.json');
});
