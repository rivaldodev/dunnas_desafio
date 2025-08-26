document.addEventListener('DOMContentLoaded', () => {
  const locale = 'pt-BR';
  const currencyFormatter = new Intl.NumberFormat(locale, { style: 'currency', currency: 'BRL' });

  document.querySelectorAll('input.money-mask').forEach(input => {
    // Preserve original name via hidden field for submission
    const hidden = document.createElement('input');
    hidden.type = 'hidden';
    hidden.name = input.name;
    input.removeAttribute('name');
    input.parentNode.insertBefore(hidden, input);

    const toNumber = (str) => {
      if (!str) return 0;
      const digits = str.replace(/\D/g, '');
      return digits ? parseInt(digits, 10) / 100 : 0;
    };

    const format = (num) => currencyFormatter.format(isNaN(num) ? 0 : num);

    function sync() {
      const valNumber = toNumber(input.value);
      input.value = format(valNumber);
      // Hidden gets canonical dot decimal for backend parsing
      hidden.value = valNumber.toFixed(2);
    }

    input.addEventListener('input', sync);
    input.addEventListener('blur', sync);
    // Initialize if pre-filled
    if (input.value) {
      sync();
    }
    input.form && input.form.addEventListener('submit', () => {
      sync();
    });
  });
});