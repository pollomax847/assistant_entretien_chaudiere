using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using AssistantChaudiere.Api.Models.Requests;
using AssistantChaudiere.Api.Services;

namespace AssistantChaudiere.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VaseExpansionController : ControllerBase
    {
        private readonly VaseExpansionService _service;

        public VaseExpansionController(VaseExpansionService service)
        {
            _service = service;
        }

        [HttpPost("Save")]
        public IActionResult Save([FromBody] VaseExpansionRequest request)
        {
            try
            {
                // Ici, vous pourriez sauvegarder les données dans une base de données
                return Ok(new { message = "Calcul sauvegardé avec succès" });
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la sauvegarde : {ex.Message}");
            }
        }

        [HttpPost("ExportPdf")]
        public async Task<IActionResult> ExportPdf([FromBody] VaseExpansionRequest request)
        {
            try
            {
                var pdfBytes = await _service.GeneratePdf(request);
                return File(pdfBytes, "application/pdf", "calcul_vase_expansion.pdf");
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la génération du PDF : {ex.Message}");
            }
        }

        private async Task<byte[]> GeneratePdf(VaseExpansionRequest request)
        {
            using (var stream = new System.IO.MemoryStream())
            {
                using (var writer = new PdfWriter(stream))
                {
                    using (var pdf = new PdfDocument(writer))
                    {
                        var document = new Document(pdf);

                        // En-tête
                        document.Add(new Paragraph("Calcul de pression du vase d'expansion")
                            .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER)
                            .SetFontSize(20)
                            .SetBold());

                        // Données d'entrée
                        document.Add(new Paragraph("\nDonnées d'entrée :")
                            .SetBold());
                        document.Add(new Paragraph($"Hauteur du bâtiment : {request.HauteurBatiment} m"));
                        document.Add(new Paragraph($"Radiateur le plus éloigné : {(request.RadiateurPlusLoin ? "au dernier étage" : "ailleurs")}"));

                        // Calcul
                        var pression = (request.HauteurBatiment / 10) + 0.3;
                        if (request.RadiateurPlusLoin)
                        {
                            pression += 0.2;
                        }
                        pression = Math.Round(pression * 2) / 2; // Arrondir à 0.5 près

                        // Résultat
                        document.Add(new Paragraph("\nRésultat :")
                            .SetBold());
                        document.Add(new Paragraph($"Pression théorique : {pression:F1} bar"));

                        // Notes de sécurité
                        document.Add(new Paragraph("\nNotes de sécurité :")
                            .SetBold());
                        document.Add(new Paragraph("1. Vérifier toujours la pression à froid avant intervention"));
                        document.Add(new Paragraph("2. Ne jamais dépasser la pression maximale indiquée sur le vase"));
                        document.Add(new Paragraph("3. Contrôler l'état du manomètre avant toute manipulation"));
                        document.Add(new Paragraph("4. Vérifier l'absence de fuites après réglage"));

                        document.Close();
                    }
                }
                return stream.ToArray();
            }
        }
    }

    public class VaseExpansionRequest
    {
        public double HauteurBatiment { get; set; }
        public bool RadiateurPlusLoin { get; set; }
    }
} 