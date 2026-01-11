'use client';

import { motion } from 'framer-motion';

export default function ProblemStatement() {
    const challenges = [
        {
            title: "Lack of Underwater Visibility",
            description: "Turbid waters make visual inspection nearly impossible for traditional cameras."
        },
        {
            title: "High Risk & Cost",
            description: "Manual diver inspections are dangerous, slow, and prohibitively expensive."
        },
        {
            title: "Data Blindspots",
            description: "Limited data availability for critical flood modeling and ecosystem health."
        },
        {
            title: "Real-time Monitoring Gap",
            description: "Current methods fail to provide immediate, actionable water quality insights."
        }
    ];

    return (
        <section className="relative w-full py-32 px-6 md:px-12 bg-[#060F14] overflow-hidden">

            {/* Background Grid Pattern */}
            <div className="absolute inset-0 bg-grid-white/[0.02] bg-[size:60px_60px] opacity-20" />
            <div className="absolute inset-0 bg-[#060F14] [mask-image:radial-gradient(ellipse_at_center,transparent_20%,black)]" />

            {/* Ambient Glow */}
            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-blue-500/10 rounded-full blur-[120px] pointer-events-none" />

            <div className="max-w-7xl mx-auto relative z-10">
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-start">

                    {/* Left Column: Heading & Quote */}
                    <div>
                        <motion.span
                            initial={{ opacity: 0, x: -20 }}
                            whileInView={{ opacity: 1, x: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.6 }}
                            className="text-[#00A3FF] font-mono text-sm tracking-widest uppercase mb-4 block"
                        >
                            The Challenge
                        </motion.span>

                        <motion.h2
                            initial={{ opacity: 0, y: 30 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.6, delay: 0.2 }}
                            className="text-4xl md:text-6xl font-bold text-white/90 tracking-tighter mb-8"
                        >
                            Why JalTejas Exists
                        </motion.h2>

                        <motion.div
                            initial={{ opacity: 0 }}
                            whileInView={{ opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 1, delay: 0.4 }}
                            className="relative p-8 border-l border-white/10 bg-white/5 rounded-r-2xl"
                        >
                            <h3 className="text-2xl md:text-3xl font-light text-white/80 leading-relaxed italic">
                                “What we can’t see underwater, we can’t protect.”
                            </h3>
                        </motion.div>
                    </div>

                    {/* Right Column: Challenges List */}
                    <div className="space-y-8 mt-8 lg:mt-0">
                        {challenges.map((challenge, index) => (
                            <motion.div
                                key={index}
                                initial={{ opacity: 0, y: 20 }}
                                whileInView={{ opacity: 1, y: 0 }}
                                viewport={{ once: true }}
                                transition={{ duration: 0.5, delay: 0.4 + (index * 0.1) }}
                                className="group p-6 rounded-xl bg-white/5 border border-white/5 hover:border-white/10 hover:bg-white/[0.07] transition-all duration-300"
                            >
                                <div className="flex items-start gap-4">
                                    <div className="mt-1 w-2 h-2 rounded-full bg-red-500/80 shadow-[0_0_10px_rgba(239,68,68,0.5)] group-hover:scale-125 transition-transform" />
                                    <div>
                                        <h4 className="text-xl font-semibold text-white/90 mb-2">{challenge.title}</h4>
                                        <p className="text-white/50 leading-relaxed text-sm md:text-base">{challenge.description}</p>
                                    </div>
                                </div>
                            </motion.div>
                        ))}
                    </div>

                </div>
            </div>
        </section>
    );
}
