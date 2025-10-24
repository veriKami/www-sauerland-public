const form = document.getElementById("contactForm");
const messageDiv = document.getElementById("messageContainer");
const btnText = document.getElementById("btnText");
const btnSpinner = document.getElementById("btnSpinner");
const submitBtn = document.getElementById("submitBtn");
const turnstileError = document.getElementById("turnstileError");
let turnstileToken = null;
const thisScript = document.querySelector("script[src=\"/lib/form.js\"]");
const lang = thisScript.dataset.lang || "pl";
const trans = {
  "Błąd weryfikacji CAPTCHA. Spróbuj ponownie.": "CAPTCHA-Verifizierungsfehler. Bitte versuchen Sie es erneut.",
  "Weryfikacja wygasła. Proszę potwierdzić ponownie.": "Die Verifizierung ist abgelaufen. Bitte bestätigen Sie erneut.",
  "Proszę potwierdzić,że nie jesteś robotem": "Bitte bestätigen Sie,dass Sie kein Roboter sind",
  "Wszystkie pola są wymagane": "Alle Felder sind Pflichtfelder",
  "Proszę podać poprawny adres email": "Bitte geben Sie eine gültige E-Mail-Adresse an",
  "Wystąpił błąd": "Ein Fehler ist aufgetreten",
  "Błąd połączenia z serwerem": "Serververbindungsfehler",
};
const $ = (str) => (lang === "pl") ? str : trans[str] || str;
window.onloadTurnstileCallback = function() {
  console.log("Turnstile ready");
};
window.turnstileSuccess = function(token) {
  console.log("Turnstile success,token:", token);
  turnstileToken = token;
  submitBtn.disabled = false;
  turnstileError.style.display = "none";
};
window.turnstileError = function() {
  console.log("Turnstile error");
  turnstileToken = null;
  submitBtn.disabled = true;
  turnstileError.textContent = $`Błąd weryfikacji CAPTCHA. Spróbuj ponownie.`;
  turnstileError.style.display = "block";
};
window.turnstileExpired = function() {
  console.log("Turnstile expired");
  turnstileToken = null;
  submitBtn.disabled = true;
  turnstileError.textContent = $`Weryfikacja wygasła. Proszę potwierdzić ponownie.`;
  turnstileError.style.display = "block";
};
form.addEventListener("submit", async (e) => {
  e.preventDefault();
  const name = document.getElementById("name").value.trim();
  const email = document.getElementById("email").value.trim();
  const message = document.getElementById("messageText").value.trim();
  console.log("Sending:", { name, email, message });
  if (!turnstileToken) {
    showMessage($`Proszę potwierdzić,że nie jesteś robotem`, "error");
    return;
  }
  if (!name || !email || !message) {
    showMessage($`Wszystkie pola są wymagane`, "error");
    return;
  }
  if (!isValidEmail(email)) {
    showMessage($`Proszę podać poprawny adres email`, "error");
    return;
  }
  setLoading(true);
  hideMessage();
  try {
    const response = await fetch(`/send?lang=${lang}`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ name, email, message, turnstileToken }) });
    const result = await response.json();
    console.log("Server response:", result);
    if (result.success) {
      showMessage(result.message, "success");
      form.reset();
      turnstileToken = null;
      submitBtn.disabled = true;
      if (window.turnstile) window.turnstile.reset();
    } else {
      showMessage(result.error || $`Wystąpił błąd`, "error");
      if (window.turnstile) window.turnstile.reset();
      turnstileToken = null;
      submitBtn.disabled = true;
    }
  } catch (error) {
    console.error("Fetch error:", error);
    showMessage($`Błąd połączenia z serwerem`, "error");
    if (window.turnstile) window.turnstile.reset();
    turnstileToken = null;
    submitBtn.disabled = true;
  } finally {
    setLoading(false);
  }
});
function showMessage(text, type) {
  messageDiv.textContent = text;
  messageDiv.className = "message " + type;
  messageDiv.style.display = "block";
  if (type === "success") setTimeout(hideMessage, 5000);
}
function hideMessage() {
  messageDiv.style.display = "none";
}
function setLoading(loading) {
  if (loading) {
    form.classList.add("loading");
    btnText.style.display = "none";
    btnSpinner.style.display = "inline";
  } else {
    form.classList.remove("loading");
    btnText.style.display = "inline";
    btnSpinner.style.display = "none";
  }
}
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
