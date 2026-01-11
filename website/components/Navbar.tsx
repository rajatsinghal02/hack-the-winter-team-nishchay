'use client';

import { motion } from 'framer-motion';
import Link from 'next/link';

export default function Navbar() {

  const handleScroll = (e: React.MouseEvent<HTMLAnchorElement, MouseEvent>, href: string) => {
    e.preventDefault();
    const targetId = href.replace('#', '');
    const element = document.getElementById(targetId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <motion.nav
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.8, ease: 'easeOut' }}
      className="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-4 md:px-12 backdrop-blur-md bg-black/10 border-b border-white/5"
    >
      {/* Brand with 3D Effect */}
      <div className="flex items-center gap-3 group cursor-pointer">
        <div className="relative w-10 h-10 perspective-1000">
          <motion.div
            className="w-full h-full relative preserve-3d transition-transform duration-500 group-hover:rotate-y-180"
          >
            {/* Front Face (Logo) */}
            <div className="absolute inset-0 bg-gradient-to-br from-[#00A3FF] to-[#0055FF] rounded-lg flex items-center justify-center backface-hidden shadow-[0_0_15px_rgba(0,163,255,0.4)]">
              <span className="text-white font-bold text-xl">J</span>
            </div>
            {/* Back Face (Icon) */}
            <div className="absolute inset-0 bg-[#060F14] border border-[#00A3FF] rounded-lg flex items-center justify-center backface-hidden rotate-y-180">
              <span className="text-[#00A3FF] text-lg">T</span>
            </div>
          </motion.div>
        </div>

        <div className="relative overflow-hidden h-6">
          <Link href="/" className="text-xl font-bold tracking-tight text-white uppercase block transition-transform duration-300 group-hover:-translate-y-full">
            JalTejas
          </Link>
          <Link href="/" className="text-xl font-bold tracking-tight text-[#00A3FF] uppercase block absolute top-full left-0 transition-transform duration-300 group-hover:-translate-y-full">
            JalTejas
          </Link>
        </div>
      </div>

      {/* Navigation Links */}
      <div className="hidden md:flex items-center space-x-8">
        {[
          { name: 'Technology', href: '#solution' },
          { name: 'Features', href: '#features' },
          { name: 'Applications', href: '#applications' },
          { name: 'Team', href: '#team' }
        ].map((item) => (
          <a
            key={item.name}
            href={item.href}
            onClick={(e) => handleScroll(e, item.href)}
            className="relative text-sm font-medium text-white/60 hover:text-white transition-colors duration-300 group"
          >
            {item.name}
            <span className="absolute -bottom-1 left-0 w-0 h-[1px] bg-[#00A3FF] transition-all duration-300 group-hover:w-full" />
          </a>
        ))}
      </div>

      {/* CTA Button */}
      <div>
        <button className="relative px-6 py-2.5 text-sm font-bold text-white bg-[#00A3FF] rounded-full overflow-hidden group transition-all duration-300 hover:scale-105 hover:shadow-[0_0_20px_rgba(0,163,255,0.4)]">
          <span className="relative z-10">Become Pilot</span>
          <div className="absolute inset-0 bg-gradient-to-r from-[#0055FF] to-[#00A3FF] opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
          <div className="absolute top-0 -left-[100%] w-full h-full bg-gradient-to-r from-transparent via-white/20 to-transparent transformSkew-x-12 group-hover:animate-shine transition-all" />
        </button>
      </div>
    </motion.nav>
  );
}
