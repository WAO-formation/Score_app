import Hero from '../../components/Hero';
import Navbar from '../../components/Navbar';
import PlaySection from '../../components/PlaySection';
import UpcomingGamesSection from '../../components/UpcomingGamesSection';
import AboutSection from '../../components/AboutSection';
import CtaSection from '../../components/CtaSection';


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
    
  </main>
);

export default LandingPage;
