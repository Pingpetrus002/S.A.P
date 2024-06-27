import {defineConfig} from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [react()],
    build: {
        outDir: 'templates',
        emptyOutDir: true,
        rollupOptions: {
            output: {
                assetFileNames: (assetInfo) => {
                    let extType = assetInfo.name.split('.').at(1);
                    if (/png|jpe?g|svg|gif|tiff|bmp|ico/i.test(extType)) {
                        extType = 'img';
                    }
                    return `assets/${extType}/[name][extname]`;
                },
                chunkFileNames: 'assets/js/[name].js',
                entryFileNames: 'assets/js/[name].js',
            },
        },
    },
    watch: {
        usePolling: true,
        interval: 500,
    },
    server: {
        port: 5000,
        proxy: {
            '/api': 'http://10.1.1.44:80',  // Proxy API requests to Flask
        },
        watch: {
            usePolling: true,
            interval: 500,
        },
    },
});
