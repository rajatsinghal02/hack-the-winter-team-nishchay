'use client';
import { motion } from 'framer-motion';

export default function Hero() {
    return (
        <section className="relative h-screen w-full flex flex-col items-center justify-center pointer-events-none">
            <div className="z-10 text-center space-y-6 max-w-4xl px-4 mt-20">
                <motion.h1
                    initial={{ opacity: 0, y: 30 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 1, delay: 0.2, ease: 'easeOut' }}
                    className="text-6xl md:text-8xl lg:text-9xl font-bold tracking-tighter text-white/90"
                >
                    JalTejas
                </motion.h1>

                <motion.p
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 1, delay: 0.4, ease: 'easeOut' }}
                    className="text-lg md:text-xl text-white/60 tracking-wide font-light"
                >
                    Next-generation autonomous systems engineered for extreme environments
                </motion.p>
            </div>

            {/* Scroll Indicator */}
            <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 1, delay: 1 }}
                className="absolute bottom-12 flex flex-col items-center gap-2"
            >
                <span className="text-[10px] uppercase tracking-[0.2em] text-white/40">Scroll to Explore</span>
                <div className="w-[1px] h-12 bg-gradient-to-b from-white/0 via-white/50 to-white/0" />
            </motion.div>
        </section>
    );
}
