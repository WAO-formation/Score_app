import { useLayoutEffect, useRef, useState } from 'react';
import { Send } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const ContactSection = () => {
  const rootRef = useRef(null);
  const [form, setForm] = useState({ name: '', email: '', phone: '', message: '' });
  const [sent, setSent] = useState(false);

  const handleChange = (e) => setForm((f) => ({ ...f, [e.target.name]: e.target.value }));

  const handleSubmit = (e) => {
    e.preventDefault();
    // TODO: wire to backend / EmailJS
    setSent(true);
    setForm({ name: '', email: '', subject: '', message: '' });
  };

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.contact-heading', '.contact-form'], { opacity: 0, y: 20 });
        gsap
          .timeline({ defaults: { ease: 'power3.out' }, scrollTrigger: { trigger: rootRef.current, start: 'top 75%' } })
          .to('.contact-heading', { opacity: 1, y: 0, duration: 0.6 })
          .to('.contact-form',    { opacity: 1, y: 0, duration: 0.6 }, '-=0.3');
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  return (
    <section id="contact" ref={rootRef} className="w-full px-6 py-20 scroll-mt-20 relative overflow-hidden">
      <div className="absolute inset-0 bg-cover bg-no-repeat bg-center" style={{ backgroundImage: "url('/assets/Hero.png')" }} />
      <div className="absolute inset-0 bg-black/60" />
      <div className="absolute inset-0" style={{ background: 'radial-gradient(ellipse at center, rgba(0,0,0,0.25) 0%, rgba(0,0,0,0.78) 75%)' }} />
      <div className="relative z-10 mx-auto max-w-2xl">

        <div className="contact-heading flex flex-col items-center text-center gap-2 mb-10">
          <p className="text-xs font-semibold uppercase tracking-[0.3em]" style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}>
            Get In Touch
          </p>
          <h2 className="text-3xl uppercase leading-[1.05] sm:text-4xl md:text-5xl" style={{ fontFamily: BRAND.font.heading, color: '#fff' }}>
            Questions? Let&apos;s Talk.
          </h2>
          <p className="mt-1 text-base leading-relaxed text-white/60" style={{ fontFamily: BRAND.font.body }}>
            Whether you want to join a clinic, bring WAO! to your school, or just know more — reach out.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="contact-form rounded-2xl p-6 sm:p-8 space-y-4" style={{ background: 'rgba(255,255,255,0.08)', backdropFilter: 'blur(16px)', WebkitBackdropFilter: 'blur(16px)', border: '1px solid rgba(255,255,255,0.15)' }}>
          {sent && (
            <p className="text-sm font-medium text-emerald-400 text-center" style={{ fontFamily: BRAND.font.body }}>
              ✓ Message sent — we'll get back to you soon!
            </p>
          )}

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            {[{ name: 'name', label: 'Your Name', type: 'text', placeholder: 'John Doe' }, { name: 'email', label: 'Email Address', type: 'email', placeholder: 'john@example.com' }].map(({ name, label, type, placeholder }) => (
              <div key={name} className="flex flex-col gap-1.5">
                <label className="text-[11px] font-semibold uppercase tracking-[0.15em] text-white/60" style={{ fontFamily: BRAND.font.body }}>{label}</label>
                <input
                  required type={type} name={name} value={form[name]} onChange={handleChange} placeholder={placeholder}
                  className="rounded-xl px-4 py-3 text-sm outline-none transition placeholder:text-white/30 text-white"
                  style={{ background: 'rgba(255,255,255,0.1)', border: '1px solid rgba(255,255,255,0.2)', fontFamily: BRAND.font.body }}
                />
              </div>
            ))}
          </div>

          <div className="flex flex-col gap-1.5">
            <label className="text-[11px] font-semibold uppercase tracking-[0.15em] text-white/60" style={{ fontFamily: BRAND.font.body }}>Phone Number</label>
            <input
              type="tel" name="phone" value={form.phone} onChange={handleChange} placeholder="+233 24 000 0000"
              className="rounded-xl px-4 py-3 text-sm outline-none transition placeholder:text-white/30 text-white"
              style={{ background: 'rgba(255,255,255,0.1)', border: '1px solid rgba(255,255,255,0.2)', fontFamily: BRAND.font.body }}
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <label className="text-[11px] font-semibold uppercase tracking-[0.15em] text-white/60" style={{ fontFamily: BRAND.font.body }}>Message</label>
            <textarea
              required name="message" rows={5} value={form.message} onChange={handleChange} placeholder="Tell us what's on your mind..."
              className="rounded-xl px-4 py-3 text-sm outline-none resize-none transition placeholder:text-white/30 text-white"
              style={{ background: 'rgba(255,255,255,0.1)', border: '1px solid rgba(255,255,255,0.2)', fontFamily: BRAND.font.body }}
            />
          </div>

          <button
            type="submit"
            className="w-full flex items-center justify-center gap-2 rounded-sm py-4 text-sm font-semibold uppercase tracking-widest text-white transition"
            style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
            onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = BRAND.primaryHover)}
            onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = BRAND.primary)}
          >
            <Send className="w-4 h-4" />
            Send Message
          </button>
        </form>

      </div>
    </section>
  );
};

export default ContactSection;
