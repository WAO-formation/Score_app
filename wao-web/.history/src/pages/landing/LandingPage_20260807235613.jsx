import Hero from '../../components/Hero';
import Navbar from '../../components/Navbar';
import PlaySection from '../../components/PlaySection';
import UpcomingGamesSection from '../../components/UpcomingGamesSection';
import AboutSection from '../../components/AboutSection';
import CtaSection from '../../components/CtaSection';
import HowToPlayPage from '../how-to-play/HowToPlayPage';
import WhyJoinSection from '../../components/WhyJoinSection';
import FaqSection from '../../components/FaqSection';
import AppCTASection from '../../components/AppCTASection';
import ContactSection from '../../components/ContactSection';


const FONTS = `@import url('https://fonts.googleapis.com/css2?family=Anton&family=Oswald:wght@400;500;600&display=swap');`;

const LandingPage = () => (
  <main className="min-h-screen overflow-hidden text-white">
    <style>{FONTS}</style>
    <Navbar />
    <Hero />
    <PlaySection />
    <UpcomingGamesSection />
    <AboutSection />
    <CtaSection />
    <HowToPlayPage />
    <WhyJoinSection />
    <FaqSection />
    <ContactSection />
    
  </main>
);

export default LandingPage;
