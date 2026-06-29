// ================================
// PRISM STUDIO — script.js
// ================================

// ── Navbar scroll effect ──
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 40);
});

// ── Rotating hero word ──
const words = ['bold', 'vibrant', 'stunning', 'unique', 'modern'];
let wordIndex = 0;
const rotatingWord = document.getElementById('rotating-word');

function rotateWord() {
  rotatingWord.style.opacity = '0';
  rotatingWord.style.transform = 'translateY(10px)';
  setTimeout(() => {
    wordIndex = (wordIndex + 1) % words.length;
    rotatingWord.textContent = words[wordIndex];
    rotatingWord.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
    rotatingWord.style.opacity = '1';
    rotatingWord.style.transform = 'translateY(0)';
  }, 300);
}
setInterval(rotateWord, 2200);

// ── Animated stat counters ──
function animateCounter(el, target, duration = 1800) {
  let start = 0;
  const step = target / (duration / 16);
  const timer = setInterval(() => {
    start += step;
    if (start >= target) {
      el.textContent = target;
      clearInterval(timer);
    } else {
      el.textContent = Math.floor(start);
    }
  }, 16);
}

// ── Intersection Observer for scroll reveals ──
const revealEls = document.querySelectorAll(
  '.stat-card, .project-card, .service-card, .team-card, .testimonial-card, .section-header'
);
revealEls.forEach(el => el.classList.add('reveal'));

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry, i) => {
    if (entry.isIntersecting) {
      // Stagger children in the same parent
      const siblings = [...entry.target.parentElement.children];
      const delay = siblings.indexOf(entry.target) * 80;
      setTimeout(() => entry.target.classList.add('visible'), delay);

      // Trigger stat counters
      const num = entry.target.querySelector('.stat-num');
      if (num && !num.dataset.counted) {
        num.dataset.counted = 'true';
        animateCounter(num, parseInt(num.dataset.target));
      }

      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.15 });

revealEls.forEach(el => observer.observe(el));

// ── Hamburger menu (mobile) ──
const hamburger = document.getElementById('hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', () => {
  const isOpen = navLinks.style.display === 'flex';
  navLinks.style.display = isOpen ? 'none' : 'flex';
  navLinks.style.flexDirection = 'column';
  navLinks.style.position = 'absolute';
  navLinks.style.top = '70px';
  navLinks.style.left = '0';
  navLinks.style.right = '0';
  navLinks.style.background = '#fff';
  navLinks.style.padding = '20px 24px';
  navLinks.style.boxShadow = '0 8px 30px rgba(0,0,0,0.1)';
  navLinks.style.gap = '20px';
  hamburger.setAttribute('aria-expanded', String(!isOpen));
});

// Close menu when a link is clicked
navLinks.querySelectorAll('a').forEach(link => {
  link.addEventListener('click', () => {
    navLinks.style.display = 'none';
  });
});

// ── Contact form ──
const form = document.getElementById('contactForm');
const formSuccess = document.getElementById('formSuccess');

form.addEventListener('submit', (e) => {
  e.preventDefault();
  const btn = form.querySelector('button[type="submit"]');
  btn.textContent = 'Sending...';
  btn.disabled = true;

  setTimeout(() => {
    form.style.display = 'none';
    formSuccess.style.display = 'block';
  }, 1200);
});

// ── Smooth active nav link highlight on scroll ──
const sections = document.querySelectorAll('section[id]');
const navAnchors = document.querySelectorAll('.nav-links a[href^="#"]');

window.addEventListener('scroll', () => {
  let current = '';
  sections.forEach(sec => {
    if (window.scrollY >= sec.offsetTop - 120) current = sec.id;
  });
  navAnchors.forEach(a => {
    a.style.color = a.getAttribute('href') === `#${current}` ? 'var(--violet)' : '';
  });
}, { passive: true });

// ── Project card hover accent border ──
document.querySelectorAll('.project-card').forEach(card => {
  const accent = getComputedStyle(card).getPropertyValue('--accent').trim();
  card.addEventListener('mouseenter', () => {
    card.style.borderColor = accent;
    card.style.boxShadow = `0 20px 60px ${accent}33`;
  });
  card.addEventListener('mouseleave', () => {
    card.style.borderColor = '';
    card.style.boxShadow = '';
  });
});
