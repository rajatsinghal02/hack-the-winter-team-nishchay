'use client';

import { motion } from 'framer-motion';

const team = [
    {
        name: "Rajat Singhal",
        role: "Project Lead",
        contribution: "Research, Documentation & ROV Design",
        gradient: "from-blue-500 to-cyan-500"
    },
    {
        name: "Vatsal Rai",
        role: "Hardware Specialist",
        contribution: "Electronics, Thrusters & Power Systems",
        gradient: "from-purple-500 to-pink-500"
    },
    {
        name: "Utsav Tiwari",
        role: "Machine Learning",
        contribution: "AI Model Development & Computer Vision",
        gradient: "from-green-500 to-emerald-500"
    },
    {
        name: "Sameer Singh Sisodia",
        role: "Full Stack Developer",
        contribution: "Web Dashboard, Cloud & System Integration",
        gradient: "from-orange-500 to-red-500"
    }
];

export default function Team() {
    return (
        <section className="relative w-full py-32 px-6 md:px-12 bg-[#060F14] overflow-hidden">

            {/* Background Grid Pattern */}
            <div className="absolute inset-0 bg-grid-white/[0.05] bg-[size:30px_30px] opacity-15" />

            <div className="max-w-7xl mx-auto relative z-10">

                {/* Header */}
                <div className="text-center mb-24">
                    <motion.span
                        initial={{ opacity: 0, y: 10 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        className="text-[#00A3FF] font-mono text-sm tracking-widest uppercase mb-4 block"
                    >
                        The Minds Behind JalTejas
                    </motion.span>
                    <motion.h2
                        initial={{ opacity: 0, y: 20 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        className="text-4xl md:text-5xl font-bold text-white/90 tracking-tighter"
                    >
                        Team & Contributions
                    </motion.h2>
                </div>

                {/* Team Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-24">
                    {team.map((member, i) => (
                        <motion.div
                            key={i}
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: i * 0.1 }}
                            className="group relative p-1 rounded-2xl bg-gradient-to-b from-white/10 to-transparent hover:from-white/20 transition-all duration-300"
                        >
                            <div className="relative h-full bg-[#081218] rounded-xl p-6 flex flex-col items-center text-center overflow-hidden">

                                {/* Abstract Avatar */}
                                <div className={`w-20 h-20 rounded-full bg-gradient-to-br ${member.gradient} mb-6 opacity-80 blur-xl absolute top-0`} />
                                <div className={`relative w-24 h-24 rounded-full bg-gradient-to-br ${member.gradient} mb-6 flex items-center justify-center shadow-lg`}>
                                    <span className="text-3xl font-bold text-white opacity-90">{member.name.charAt(0)}</span>
                                </div>

                                <h3 className="text-xl font-bold text-white mb-2">{member.name}</h3>
                                <span className="text-[#00A3FF] font-mono text-xs uppercase tracking-wider mb-4 block">{member.role}</span>

                                <div className="w-full h-[1px] bg-white/5 mb-4" />

                                <p className="text-white/60 text-sm leading-relaxed">
                                    {member.contribution}
                                </p>
                            </div>
                        </motion.div>
                    ))}
                </div>

                {/* Equal Contribution Chart */}
                <div className="max-w-2xl mx-auto text-center">
                    <motion.h3
                        initial={{ opacity: 0 }}
                        whileInView={{ opacity: 1 }}
                        viewport={{ once: true }}
                        className="text-white/80 font-light mb-12"
                    >
                        Contribution Distribution
                    </motion.h3>

                    <div className="flex justify-center items-center gap-12 flex-wrap">
                        {/* Simple CSS Donut Chart Representation for "Equal" */}
                        <motion.div
                            initial={{ scale: 0.8, opacity: 0 }}
                            whileInView={{ scale: 1, opacity: 1 }}
                            viewport={{ once: true }}
                            className="relative w-48 h-48 rounded-full border-8 border-white/10 flex items-center justify-center"
                        >
                            {/* 4 Segments overlay */}
                            <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 100 100">
                                <circle cx="50" cy="50" r="40" fill="transparent" stroke="#3B82F6" strokeWidth="10" strokeDasharray="62.8 251.2" strokeDashoffset="0" /> {/* Blue */}
                                <circle cx="50" cy="50" r="40" fill="transparent" stroke="#A855F7" strokeWidth="10" strokeDasharray="62.8 251.2" strokeDashoffset="-62.8" /> {/* Purple */}
                                <circle cx="50" cy="50" r="40" fill="transparent" stroke="#10B981" strokeWidth="10" strokeDasharray="62.8 251.2" strokeDashoffset="-125.6" /> {/* Green */}
                                <circle cx="50" cy="50" r="40" fill="transparent" stroke="#F97316" strokeWidth="10" strokeDasharray="62.8 251.2" strokeDashoffset="-188.4" /> {/* Orange */}
                            </svg>
                            <div className="text-center">
                                <span className="text-3xl font-bold text-white block">100%</span>
                                <span className="text-xs text-white/50 uppercase tracking-widest">Teamwork</span>
                            </div>
                        </motion.div>

                        <div className="space-y-4 text-left">
                            {team.map((m, i) => (
                                <div key={i} className="flex items-center gap-3">
                                    <div className={`w-3 h-3 rounded-full bg-gradient-to-r ${m.gradient}`} />
                                    <span className="text-white/70 text-sm">25% — {m.name}</span>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>

            </div>
        </section>
    );
}
