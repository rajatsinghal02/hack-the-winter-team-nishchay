'use client';

import { motion, useScroll, useTransform } from 'framer-motion';
import { useRef } from 'react';

const features = [
    {
        title: "Remote Controlled",
        desc: "Precision maneuvering with low-latency control systems tailored for tight underwater spaces."
    },
    {
        title: "Real-time Video",
        desc: "Crystal clear 4K streaming feed ensuring zero visibility loss during critical inspections."
    },
    {
        title: "AI-Based Detection",
        desc: "Onboard neural processing to automatically identify fractures, debris, and structural anomalies."
    },
    {
        title: "Sensor Monitoring",
        desc: "Equipped with advanced multi-parameter sensors for depth, pressure, and temperature logging."
    }
];

const steps = [
    { title: "Deploy", desc: "Deploy JalTejas into river", icon: "🚀" },
    { title: "Navigate", desc: "ROV navigates using thrusters", icon: "🕹️" },
    { title: "Capture", desc: "Camera captures underwater feed", icon: "🎥" },
    { title: "AI Process", desc: "AI processes video on Raspberry Pi", icon: "🧠" },
    { title: "Sensors", desc: "Sensors collect water data", icon: "🌡️" },
    { title: "Dashboard", desc: "Data sent to live dashboard", icon: "📊" },
    { title: "Insights", desc: "Insights used for monitoring & decisions", icon: "💡" },
];

export default function SolutionOverview() {
    const containerRef = useRef<HTMLDivElement>(null);
    const { scrollYProgress } = useScroll({
        target: containerRef,
        offset: ["start end", "end start"]
    });

    // Animated line height based on scroll
    const lineHeight = useTransform(scrollYProgress, [0.2, 0.8], ["0%", "100%"]);

    return (
        <section className="relative w-full py-32 px-6 md:px-12 bg-[#060F14] overflow-hidden">

            {/* Background Elements */}
            <div className="absolute inset-0 bg-grid-white/[0.05] bg-[size:40px_40px] opacity-20" />
            <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-blue-500/10 rounded-full blur-[120px] pointer-events-none" />

            <div className="max-w-7xl mx-auto space-y-32 relative z-10">

                {/* Header & Intro */}
                <div className="space-y-24">
                    <div className="text-center max-w-3xl mx-auto">
                        <motion.span
                            initial={{ opacity: 0, y: 10 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.6 }}
                            className="text-[#00A3FF] font-mono text-sm tracking-widest uppercase mb-4 block"
                        >
                            The Solution
                        </motion.span>
                        <motion.h2
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.6, delay: 0.1 }}
                            className="text-4xl md:text-5xl font-bold text-white/90 tracking-tighter mb-6"
                        >
                            Meet JalTejas ROV
                        </motion.h2>
                        <motion.p
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.6, delay: 0.2 }}
                            className="text-lg text-white/60 leading-relaxed"
                        >
                            An advanced, modular Remotely Operated Vehicle designed to bridge the gap between human limitation and underwater complexity.
                            Merging robust mechanical engineering with cutting-edge AI.
                        </motion.p>
                    </div>


                    {/* Capabilities Grid */}
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        {features.map((item, i) => (
                            <motion.div
                                key={i}
                                initial={{ opacity: 0, y: 20 }}
                                whileInView={{ opacity: 1, y: 0 }}
                                viewport={{ once: true }}
                                transition={{ duration: 0.5, delay: 0.3 + (i * 0.1) }}
                                className="p-8 border border-white/5 bg-white/[0.02] rounded-2xl hover:bg-white/[0.04] transition-colors"
                            >
                                <div className="w-12 h-1 mb-6 bg-gradient-to-r from-[#00A3FF] to-transparent rounded-full" />
                                <h3 className="text-xl font-semibold text-white/90 mb-3">{item.title}</h3>
                                <p className="text-sm text-white/50 leading-relaxed">{item.desc}</p>
                            </motion.div>
                        ))}
                    </div>
                </div>

                {/* How It Works - Vertical Scroll Animation */}
                <div ref={containerRef} className="relative border-t border-white/5 pt-24">
                    <div className="text-center mb-16">
                        <motion.h3
                            initial={{ opacity: 0 }}
                            whileInView={{ opacity: 1 }}
                            viewport={{ once: true }}
                            className="text-3xl md:text-4xl font-bold text-white/90"
                        >
                            How It Works
                        </motion.h3>
                        <p className="text-white/40 mt-4">Step-by-step autonomous operation flow</p>
                    </div>

                    <div className="relative max-w-4xl mx-auto">
                        {/* Center Line Background */}
                        <div className="absolute left-[20px] md:left-1/2 top-0 bottom-0 w-[1px] bg-white/5 ml-[-0.5px] md:ml-0" />

                        {/* Animated Fill Line */}
                        <motion.div
                            style={{ height: lineHeight }}
                            className="absolute left-[20px] md:left-1/2 top-0 w-[1px] bg-gradient-to-b from-[#00A3FF] via-[#00A3FF] to-transparent ml-[-0.5px] md:ml-0 origin-top"
                        />

                        <div className="space-y-16 md:space-y-24 relative z-10 py-12">
                            {steps.map((step, index) => (
                                <motion.div
                                    key={index}
                                    initial={{ opacity: 0, y: 50, rotateX: -10 }}
                                    whileInView={{ opacity: 1, y: 0, rotateX: 0 }}
                                    viewport={{ once: true, margin: "-100px" }}
                                    transition={{ duration: 0.8, type: "spring", bounce: 0.4 }}
                                    className={`flex flex-col md:flex-row items-center gap-8 ${index % 2 === 0 ? 'md:flex-row-reverse' : ''}`}
                                >
                                    {/* Content Card */}
                                    <div className="flex-1 w-full pl-16 md:pl-0">
                                        <div className={`p-6 rounded-2xl border border-white/10 bg-white/5 backdrop-blur-sm shadow-[0_0_30px_rgba(0,0,0,0.5)] transform transition-transform hover:-translate-y-2 hover:shadow-[0_0_30px_rgba(0,163,255,0.1)] ${index % 2 === 0 ? 'md:text-right' : 'md:text-left'}`}>
                                            <h4 className="text-[#00A3FF] font-mono text-sm mb-2">Step 0{index + 1}</h4>
                                            <h3 className="text-xl font-bold text-white mb-2">{step.title}</h3>
                                            <p className="text-white/60 text-sm leading-relaxed">{step.desc}</p>
                                        </div>
                                    </div>

                                    {/* Center Icon */}
                                    <div className="absolute left-[20px] md:left-1/2 transform -translate-x-1/2 flex items-center justify-center">
                                        <div className="w-10 h-10 rounded-full bg-[#060F14] border-2 border-[#00A3FF] flex items-center justify-center shadow-[0_0_20px_rgba(0,163,255,0.4)] z-10">
                                            <span className="text-sm">{step.icon}</span>
                                        </div>
                                    </div>

                                    {/* Empty Spacer for alternate side */}
                                    <div className="flex-1 hidden md:block" />
                                </motion.div>
                            ))}
                        </div>
                    </div>
                </div>

            </div>
        </section>
    );
}
