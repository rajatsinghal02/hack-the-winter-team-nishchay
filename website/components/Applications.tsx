'use client';

import { motion } from 'framer-motion';

const useCases = [
    {
        title: "River Ecosystem Monitoring",
        category: "Environment",
        image: "/app-ecosystem.png", // Generated
        colSpan: "md:col-span-2",
    },
    {
        title: "Pollution & Waste Detection",
        category: "Sustainability",
        image: "", // CSS Gradient Fallback
        colSpan: "md:col-span-1",
        gradient: "bg-gradient-to-br from-red-900/40 to-black"
    },
    {
        title: "Sediment & Riverbed Mapping",
        category: "Geology",
        image: "",
        colSpan: "md:col-span-1",
        gradient: "bg-gradient-to-br from-amber-900/40 to-black"
    },
    {
        title: "Aquatic Biodiversity Observation",
        category: "Research",
        image: "/app-ecosystem.png", // Reuse ecosystem
        colSpan: "md:col-span-1",
    },
    {
        title: "Infrastructure Inspection",
        category: "Civil Engineering",
        image: "/app-infrastructure.png", // Generated
        colSpan: "md:col-span-2",
    },
    {
        title: "Disaster & Flood Response",
        category: "Emergency",
        image: "",
        colSpan: "md:col-span-1",
        gradient: "bg-gradient-to-br from-blue-900/40 to-black"
    },
    {
        title: "Digital Twin & Policy Support",
        category: "Data Science",
        image: "/app-digital-twin.png", // Generated
        colSpan: "md:col-span-3",
    }
];

export default function Applications() {
    return (
        <section className="relative w-full py-32 px-6 md:px-12 bg-[#060F14] overflow-hidden">

            {/* Background Grid Pattern */}
            <div className="absolute inset-0 bg-grid-white/[0.05] bg-[size:50px_50px] opacity-20" />
            <div className="absolute inset-0 bg-[#060F14] [mask-image:radial-gradient(ellipse_at_center,transparent_20%,black)]" />

            <div className="max-w-7xl mx-auto mb-16 relative z-10">
                <motion.span
                    initial={{ opacity: 0, x: -20 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    viewport={{ once: true }}
                    className="text-[#00A3FF] font-mono text-sm tracking-widest uppercase mb-4 block"
                >
                    Real-World Impact
                </motion.span>
                <motion.h2
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    className="text-4xl md:text-6xl font-bold text-white/90 tracking-tighter"
                >
                    Applications & Use Cases
                </motion.h2>
            </div>

            <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6 auto-rows-[300px]">
                {useCases.map((item, i) => (
                    <motion.div
                        key={i}
                        initial={{ opacity: 0, scale: 0.95 }}
                        whileInView={{ opacity: 1, scale: 1 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.5, delay: i * 0.05 }}
                        className={`relative group rounded-3xl overflow-hidden border border-white/10 ${item.colSpan} ${!item.image ? item.gradient : 'bg-black'}`}
                    >
                        {/* Background Image */}
                        {item.image && (
                            <div className="absolute inset-0">
                                <img
                                    src={item.image}
                                    alt={item.title}
                                    className="w-full h-full object-cover opacity-60 group-hover:opacity-40 group-hover:scale-105 transition-all duration-700"
                                />
                                <div className="absolute inset-0 bg-gradient-to-t from-[#060F14] via-transparent to-transparent opacity-90" />
                            </div>
                        )}

                        {/* Content */}
                        <div className="absolute inset-0 p-8 flex flex-col justify-end">
                            <span className="text-xs font-mono text-[#00A3FF] mb-2 px-3 py-1 rounded-full border border-white/10 bg-black/40 w-fit backdrop-blur-md">
                                {item.category}
                            </span>
                            <h3 className="text-2xl font-bold text-white/95 leading-tight group-hover:translate-x-2 transition-transform duration-300">
                                {item.title}
                            </h3>
                        </div>
                    </motion.div>
                ))}
            </div>
        </section>
    );
}
