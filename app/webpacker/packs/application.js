require.context('govuk-frontend/govuk/assets');

import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { initAll } from 'govuk-frontend';
import { autocompleteSelection } from "./autocomplete.js";

Rails.start();
Turbolinks.start();
initAll();

autocompleteSelection('#autocomplete_trusts', '/trusts/search.json');
