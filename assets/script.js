// Mobile menu — open/close, body lock, ESC, link-tap close
const menuBtn = document.querySelector('.menu-btn');
const mobileMenu = document.querySelector('#mobileMenu');

function setMenu(open){
  if(!menuBtn || !mobileMenu) return;
  menuBtn.setAttribute('aria-expanded', String(open));
  mobileMenu.classList.toggle('open', open);
  document.body.classList.toggle('menu-open', open);
}

if(menuBtn && mobileMenu){
  menuBtn.addEventListener('click', () => {
    const open = menuBtn.getAttribute('aria-expanded') === 'true';
    setMenu(!open);
  });
  mobileMenu.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => setMenu(false));
  });
  document.addEventListener('keydown', e => {
    if(e.key === 'Escape') setMenu(false);
  });
  // Close menu if viewport grows past mobile breakpoint
  const mq = window.matchMedia('(min-width: 880px)');
  mq.addEventListener('change', e => { if(e.matches) setMenu(false); });
}

// FAQ accordion
document.querySelectorAll('.faq-q').forEach(btn => {
  btn.addEventListener('click', () => btn.closest('.faq-item').classList.toggle('active'));
});

// Year
const year = document.querySelector('#year');
if(year) year.textContent = new Date().getFullYear();

// Sticky nav shadow + scroll progress
const nav = document.querySelector('.nav');
const progress = document.createElement('div');
progress.className = 'scroll-progress';
document.body.appendChild(progress);

const onScroll = () => {
  if(nav) nav.classList.toggle('scrolled', window.scrollY > 8);
  const h = document.documentElement;
  const max = h.scrollHeight - h.clientHeight;
  const pct = max > 0 ? (window.scrollY / max) * 100 : 0;
  progress.style.width = pct + '%';
};
onScroll();
window.addEventListener('scroll', onScroll, {passive:true});

// Reveal on scroll
if('IntersectionObserver' in window){
  const io = new IntersectionObserver(es => {
    es.forEach(e => { if(e.isIntersecting){ e.target.classList.add('in'); io.unobserve(e.target); } });
  }, {threshold:.12, rootMargin:'0px 0px -40px 0px'});
  document.querySelectorAll('.reveal').forEach(el => io.observe(el));
}
