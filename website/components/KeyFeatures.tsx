'use client';

import { motion } from 'framer-motion';

const features = [
    {
        icon: "🚤",
        title: "Underwater Mobility",
        desc: "Multi-directional thrusters"
    },
    {
        icon: "🎥",
        title: "Live Camera Feed",
        desc: "Low-visibility river support"
    },
    {
        icon: "🧠",
        title: "AI Vision System",
        desc: "Garbage / object detection"
    },
    {
        icon: "🌡️",
        title: "Environmental Sensors",
        desc: "pH, temperature, turbidity, DO"
    },
    {
        icon: "📊",
        title: "Real-Time Dashboard",
        desc: "Live data + charts"
    },
    {
        icon: "🔌",
        title: "Raspberry Pi Powered",
        desc: "Edge computing onboard"
    },
    {
        icon: "🔗",
        title: "Tethered Communication",
        desc: "Stable & safe operations"
    }
];

export default function KeyFeatures() {
    return (
        <section className="relative w-full py-32 px-6 md:px-12 bg-[#060F14] overflow-hidden">

            {/* Background Grid Pattern */}
            <div className="absolute inset-0 bg-grid-white/[0.05] bg-[size:40px_40px] opacity-20" />
            <div className="absolute inset-0 bg-[#060F14] [mask-image:radial-gradient(ellipse_at_center,transparent_20%,black)]" />

            {/* Ambient Glow */}
            <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-purple-500/10 rounded-full blur-[120px] pointer-events-none" />

            <div className="max-w-7xl mx-auto relative z-10">

                {/* Header */}
                <div className="text-center mb-20">
                    <motion.span
                        initial={{ opacity: 0, y: 10 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.6 }}
                        className="text-[#00A3FF] font-mono text-sm tracking-widest uppercase mb-4 block"
                    >
                        Core Strengths
                    </motion.span>
                    <motion.h2
                        initial={{ opacity: 0, y: 20 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.6, delay: 0.1 }}
                        className="text-4xl md:text-5xl font-bold text-white/90 tracking-tighter"
                    >
                        Technical Innovation
                    </motion.h2>
                </div>

                {/* Features Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {features.map((feature, i) => (
                        <motion.div
                            key={i}
                            initial={{ opacity: 0, scale: 0.95 }}
                            whileInView={{ opacity: 1, scale: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: i * 0.1 }}
                            className={`group p-8 rounded-2xl border border-white/5 bg-white/[0.02] hover:bg-white/[0.05] hover:border-white/10 transition-all duration-300 ${i === features.length - 1 ? 'md:col-span-2 lg:col-span-3 text-center' : ''}`}
                        >
                            <div className={`text-4xl mb-6 ${i === features.length - 1 ? 'inline-block' : ''}`}>
                                {feature.icon}
                            </div>
                            <h3 className="text-xl font-semibold text-white/90 mb-2">{feature.title}</h3>
                            <p className="text-white/50">{feature.desc}</p>
                        </motion.div>
                    ))}
                </div>

            </div>
        </section>
    );
}
