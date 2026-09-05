"use client";
import { useEffect } from "react";

export function ResponsiveScale() {
  useEffect(() => {
    const DESIGN_WIDTH = 590;
    const apply = () => {
      const frame = document.querySelector(".app-frame") as HTMLElement | null;
      if (!frame) return;
      const scale = Math.min(1, window.innerWidth / DESIGN_WIDTH);
      frame.style.zoom = String(scale);
    };
    apply();
    window.addEventListener("resize", apply);
    window.addEventListener("orientationchange", apply);
    return () => {
      window.removeEventListener("resize", apply);
      window.removeEventListener("orientationchange", apply);
    };
  }, []);
  return null;
}
