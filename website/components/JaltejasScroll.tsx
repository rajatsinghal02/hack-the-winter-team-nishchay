'use client';

import { useEffect, useRef, useState } from 'react';
import { useScroll, useTransform, motion, useMotionValueEvent } from 'framer-motion';

const FRAME_COUNT = 40;
const FRAME_PREFIX = 'ezgif-frame-';
const FRAME_DIGITS = 3;

export default function JaltejasScroll() {
    const containerRef = useRef<HTMLDivElement>(null);
    const canvasRef = useRef<HTMLCanvasElement>(null);
    const [images, setImages] = useState<HTMLImageElement[]>([]);
    const [loaded, setLoaded] = useState(false);

    // Scroll progress for the entire container
    const { scrollYProgress } = useScroll({
        target: containerRef,
        offset: ['start start', 'end end'],
    });

    // Map scroll progress 0-1 to frame index 0-39
    const frameIndex = useTransform(scrollYProgress, [0, 1], [0, FRAME_COUNT - 1]);

    // Preload images
    useEffect(() => {
        let loadedCount = 0;
        const imgArray: HTMLImageElement[] = [];

        for (let i = 1; i <= FRAME_COUNT; i++) {
            const img = new Image();
            const frameNumber = i.toString().padStart(FRAME_DIGITS, '0');
            img.src = `/sequences/${FRAME_PREFIX}${frameNumber}.jpg`;

            img.onload = () => {
                loadedCount++;
                if (loadedCount === FRAME_COUNT) {
                    setLoaded(true);
                }
            };
            imgArray.push(img);
        }
        setImages(imgArray);
    }, []);

    // Render Loop
    const renderFrame = (index: number) => {
        const canvas = canvasRef.current;
        if (!canvas || !images[index]) return;

        const ctx = canvas.getContext('2d');
        if (!ctx) return;

        const img = images[index];

        // Responsive "contain" logic for canvas
        const canvasWidth = canvas.width;
        const canvasHeight = canvas.height;
        const imgRatio = img.width / img.height;
        const canvasRatio = canvasWidth / canvasHeight;


        // Calculate scale to COVER the viewport (no empty space)
        const scale = Math.max(canvasWidth / img.width, canvasHeight / img.height);

        const drawWidth = img.width * scale;
        const drawHeight = img.height * scale;

        // Center the image
        const offsetX = (canvasWidth - drawWidth) / 2;
        const offsetY = (canvasHeight - drawHeight) / 2;

        ctx.clearRect(0, 0, canvasWidth, canvasHeight);
        ctx.drawImage(img, offsetX, offsetY, drawWidth, drawHeight);
    };

    // Sync scroll to canvas
    useMotionValueEvent(frameIndex, "change", (latest) => {
        if (!loaded) return;
        const index = Math.min(FRAME_COUNT - 1, Math.max(0, Math.floor(latest)));
        requestAnimationFrame(() => renderFrame(index));
    });

    // Initial resize and render
    useEffect(() => {
        if (!loaded || !canvasRef.current) return;

        const handleResize = () => {
            const canvas = canvasRef.current;
            if (canvas) {
                canvas.width = window.innerWidth;
                canvas.height = window.innerHeight;
                // Re-render current frame
                renderFrame(Math.min(FRAME_COUNT - 1, Math.max(0, Math.floor(frameIndex.get()))));
            }
        };

        window.addEventListener('resize', handleResize);
        handleResize(); // Initial sizing

        return () => window.removeEventListener('resize', handleResize);
    }, [loaded]);


    // Text Overlay Opacity Maps
    const opacity1 = useTransform(scrollYProgress, [0, 0.15, 0.25], [1, 1, 0]);
    const y1 = useTransform(scrollYProgress, [0, 0.25], [0, -50]);

    const opacity2 = useTransform(scrollYProgress, [0.25, 0.35, 0.45, 0.55], [0, 1, 1, 0]);
    const y2 = useTransform(scrollYProgress, [0.25, 0.35, 0.55], [50, 0, -50]);

    const opacity3 = useTransform(scrollYProgress, [0.55, 0.65, 0.75, 0.85], [0, 1, 1, 0]);
    const y3 = useTransform(scrollYProgress, [0.55, 0.65, 0.85], [50, 0, -50]);

    const opacity4 = useTransform(scrollYProgress, [0.85, 0.95, 1], [0, 1, 1]);
    const y4 = useTransform(scrollYProgress, [0.85, 1], [50, 0]);


    return (
        <div ref={containerRef} className="relative h-[500vh] bg-[#060F14]">

            {/* Loading Overlay */}
            {!loaded && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-[#060F14]">
                    <div className="flex flex-col items-center gap-4">
                        <div className="w-12 h-12 border-4 border-white/20 border-t-white/90 rounded-full animate-spin" />
                        <span className="text-white/40 text-sm tracking-widest uppercase">Initializing Systems</span>
                    </div>
                </div>
            )}

            {/* Sticky Canvas */}
            <div className="sticky top-18 h-screen w-full overflow-hidden">
                <canvas ref={canvasRef} className="block w-full h-full object-contain" />
            </div>

            {/* Text Overlays */}
            <div className="absolute inset-0 pointer-events-none">
                <div className="sticky top-0 h-screen w-full flex items-center justify-center">

                    {/* HERO SECTION / Frame 0 Content */}
                    <motion.div
                        style={{ opacity: opacity1, y: y1 }}
                        className="absolute text-center max-w-4xl px-4 flex flex-col items-center justify-center h-full"
                    >
                        <div className="translate-y-[10vh]">
                            <h1 className="text-6xl md:text-8xl lg:text-9xl font-bold tracking-tighter text-white/90 mb-6">
                                JalTejas
                            </h1>
                            <p className="text-lg md:text-xl text-white/60 tracking-wide font-light mb-12">
                                Next-generation autonomous systems engineered for extreme environments
                            </p>

                            <div className="flex flex-col items-center gap-2">
                                <span className="text-[10px] uppercase tracking-[0.2em] text-white/40">Scroll to Explore</span>
                                <div className="w-[1px] h-12 bg-gradient-to-b from-white/0 via-white/50 to-white/0" />
                            </div>
                        </div>
                    </motion.div>

                    {/* Text 2: 30% - Left Aligned */}
                    <motion.div style={{ opacity: opacity2, y: y2 }} className="absolute left-0 w-full md:w-1/2 px-12 md:px-24">
                        <h3 className="text-3xl md:text-5xl font-semibold text-white/90 mb-4">Modular intelligence.</h3>
                        <p className="text-xl text-white/60">Precision-engineered systems designed for modular adaptability.</p>
                    </motion.div>

                    {/* Text 3: 60% - Right Aligned */}
                    <motion.div style={{ opacity: opacity3, y: y3 }} className="absolute right-0 w-full md:w-1/2 px-12 md:px-24 text-right">
                        <h3 className="text-3xl md:text-5xl font-semibold text-white/90 mb-4">Optimized Core.</h3>
                        <p className="text-xl text-white/60">Every component optimized for autonomy and resilience in high-pressure environments.</p>
                    </motion.div>

                    {/* Text 4: 90% - Center */}
                    <motion.div style={{ opacity: opacity4, y: y4 }} className="absolute text-center max-w-3xl px-6 pointer-events-auto">
                        <h2 className="text-5xl md:text-7xl font-bold text-white/90 tracking-tighter mb-6">JalTejas</h2>
                        <p className="text-2xl text-white/50 mb-10">Built for the Unknown.</p>

                        <button className="relative px-8 py-3 text-base font-bold text-white bg-[#00A3FF] rounded-full overflow-hidden group transition-all duration-300 hover:scale-105 hover:shadow-[0_0_30px_rgba(0,163,255,0.4)]">
                            <span className="relative z-10">Become Pilot</span>
                            <div className="absolute inset-0 bg-gradient-to-r from-[#0055FF] to-[#00A3FF] opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                            <div className="absolute top-0 -left-[100%] w-full h-full bg-gradient-to-r from-transparent via-white/20 to-transparent transformSkew-x-12 group-hover:animate-shine transition-all" />
                        </button>
                    </motion.div>

                </div>
            </div>
        </div>
    );
}
