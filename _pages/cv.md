---
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}
Here's the pdf <a href="/files/pdf/cv_web.pdf" class="btn--faicon"><i class="fa fa-cloud-arrow-down"></i></a>

<div id="pdf-container"></div>

<font color="#56018D"> <i class="fa fa-crow"></i> ... <i class="fa fa-worm"></i></font>

<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.min.js"></script>

<script>
    const url = '/files/pdf/cv_web.pdf';

    const loadingTask = pdfjsLib.getDocument(url);
    loadingTask.promise.then(pdf => {
        const totalPages = pdf.numPages;
        const container = document.getElementById('pdf-container');

        for (let pageNum = 1; pageNum <= totalPages; pageNum++) {
            pdf.getPage(pageNum).then(page => {
                const scale = 3.0; // You can increase this
                const viewport = page.getViewport({ scale: scale });

                const canvas = document.createElement('canvas');
                canvas.className = 'pdf-page';
                
                // Set canvas dimensions for higher resolution
                canvas.width = viewport.width*scale; 
                canvas.height = viewport.height*scale; 

                const context = canvas.getContext('2d');
                context.scale(scale, scale); // Scale the context

                container.appendChild(canvas);

                const renderContext = {
                    canvasContext: context,
                    viewport: viewport
                };
                page.render(renderContext);
            });
        }
    }).catch(error => {
        console.error('Error loading PDF:', error);
    });
</script>

<style>
#pdf-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    max-width: 800px; /* Limit the maximum width of the container */
    margin: 0 auto; /* Center the container */
    padding: 0; /* Remove padding */
    overflow: hidden; /* Prevent overflow */
}

.pdf-page {
    margin: 5px; /* Remove margin between pages */
    width: 100%; /* Make canvas responsive */
    height: auto; /* Maintain aspect ratio */
    border: 2px solid #56018D; /* Purple outline */
    border-radius: 4px; /* Optional: add slight rounding to corners */
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Optional: add a shadow for depth */
}
</style>
