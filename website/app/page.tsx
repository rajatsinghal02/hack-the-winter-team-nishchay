'use client';

import Navbar from "@/components/Navbar";
import JaltejasScroll from "@/components/JaltejasScroll";
import ProblemStatement from "@/components/ProblemStatement";
import SolutionOverview from "@/components/SolutionOverview";
import KeyFeatures from "@/components/KeyFeatures";
import Applications from "@/components/Applications";
import Team from "@/components/Team";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <main className="bg-black min-h-screen selection:bg-white/20 selection:text-white">
      <Navbar />

      {/* Scroll Experience (Hero + Explode) */}
      <div className="relative z-0">
        <JaltejasScroll />
      </div>

      {/* Problem Statement Section */}
      <div id="problem" className="relative z-10 bg-[#060F14]">
        <ProblemStatement />
      </div>

      {/* Solution Overview Section */}
      <div id="solution" className="relative z-10 bg-[#060F14]">
        <SolutionOverview />
      </div>

      {/* Key Features Section */}
      <div id="features" className="relative z-10 bg-[#060F14]">
        <KeyFeatures />
      </div>

      {/* Applications Section */}
      <div id="applications" className="relative z-10 bg-[#060F14]">
        <Applications />
      </div>

      {/* Team Section */}
      <div id="team" className="relative z-10 bg-[#060F14]">
        <Team />
      </div>

      {/* Footer */}
      <div className="relative z-10 bg-[#060F14]">
        <Footer />
      </div>
    </main>
  );
}
