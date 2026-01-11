'use client';

import Link from 'next/link';

export default function Footer() {
    const links = {
        Product: ['Technology', 'Features', 'Applications', 'Specifications'],
        Company: ['About Us', 'Team', 'Careers', 'Contact'],
        Resources: ['Blog', 'Research Papers', 'Documentation', 'Support']
    };

    return (
        <footer className="w-full bg-[#060F14] border-t border-white/5 pt-20 pb-10 px-6 md:px-12">
            <div className="max-w-7xl mx-auto">

                {/* Top Section */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-12 mb-20">

                    {/* Brand Column */}
                    <div className="lg:col-span-2">
                        <Link href="/" className="text-2xl font-bold tracking-tight text-white uppercase mb-6 block">
                            JalTejas
                        </Link>
                        <p className="text-white/50 text-sm leading-relaxed max-w-xs mb-8">
                            Pioneering autonomous underwater technology for a sustainable and simpler future.
                            Exploring the unknown, protecting the essential.
                        </p>

                        {/* Socials Placeholder */}
                        <div className="flex gap-4">
                            {['Twitter', 'LinkedIn', 'GitHub', 'Youtube'].map((social) => (
                                <a
                                    key={social}
                                    href="#"
                                    className="w-8 h-8 rounded-full bg-white/5 hover:bg-white/10 flex items-center justify-center transition-colors group"
                                    aria-label={social}
                                >
                                    <div className="w-4 h-4 bg-white/40 group-hover:bg-white/90 rounded-sm transition-colors" />
                                </a>
                            ))}
                        </div>
                    </div>

                    {/* Links Columns */}
                    {Object.entries(links).map(([category, items]) => (
                        <div key={category} className="lg:col-span-1">
                            <h4 className="text-white font-semibold mb-6">{category}</h4>
                            <ul className="space-y-3">
                                {items.map((item) => (
                                    <li key={item}>
                                        <a href="#" className="text-white/50 hover:text-[#00A3FF] text-sm transition-colors">
                                            {item}
                                        </a>
                                    </li>
                                ))}
                            </ul>
                        </div>
                    ))}

                    {/* Newsletter Column */}
                    <div className="lg:col-span-1">
                        <h4 className="text-white font-semibold mb-6">Stay Updated</h4>
                        <form className="space-y-4">
                            <div className="relative">
                                <input
                                    type="email"
                                    placeholder="Enter your email"
                                    className="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-2 text-sm text-white placeholder:text-white/30 focus:outline-none focus:border-[#00A3FF]/50"
                                />
                            </div>
                            <button className="w-full bg-[#00A3FF]/10 text-[#00A3FF] border border-[#00A3FF]/20 py-2 rounded-lg text-sm font-medium hover:bg-[#00A3FF] hover:text-white transition-all">
                                Subscribe
                            </button>
                        </form>
                    </div>

                </div>

                {/* Bottom Section */}
                <div className="border-t border-white/5 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-white/30">
                    <p>© 2026 JalTejas Inc. All rights reserved.</p>
                    <div className="flex gap-8">
                        <a href="#" className="hover:text-white/50 transition-colors">Privacy Policy</a>
                        <a href="#" className="hover:text-white/50 transition-colors">Terms of Service</a>
                        <a href="#" className="hover:text-white/50 transition-colors">Cookie Settings</a>
                    </div>
                </div>

            </div>
        </footer>
    );
}
