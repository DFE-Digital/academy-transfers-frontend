// Solution based on https://github.com/alphagov/accessible-autocomplete/issues/210
import accessibleAutocomplete from 'accessible-autocomplete'

function debounce(fn, delay) {
  let timer = null;
  return function () {
    let context = this, args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);
    }, delay);
  };
}

async function fetchSource( sourceUrl, query ) {
  const res  = await fetch( `${sourceUrl}?input-autocomplete=${encodeURIComponent( query )}` );
  const data = await res.json();
  return data;
}

export function autocompleteSelection(targetId, sourceUrl) {
  let element = document.querySelector(targetId);
  if(element) {
    accessibleAutocomplete({
      element: element,
      id: 'query',
      minLength: 2,
      source: debounce(
        async ( query, populateResults ) => {
          const res = await fetchSource( sourceUrl, query );
          populateResults( res );
        },
        100
      )
    })
  }
}
