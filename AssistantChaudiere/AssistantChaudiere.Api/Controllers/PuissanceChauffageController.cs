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
    public class PuissanceChauffageController : ControllerBase
    {
        private readonly PuissanceChauffageService _service;

        public PuissanceChauffageController(PuissanceChauffageService service)
        {
            _service = service;
        }

        [HttpPost("Save")]
        public IActionResult Save([FromBody] PuissanceChauffageRequest request)
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
        public async Task<IActionResult> ExportPdf([FromBody] PuissanceChauffageRequest request)
        {
            try
            {
                var pdfBytes = await _service.GeneratePdf(request);
                return File(pdfBytes, "application/pdf", "calcul_puissance_chauffage.pdf");
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la génération du PDF : {ex.Message}");
            }
        }
    }

    public class PuissanceChauffageRequest
    {
        public double Surface { get; set; }
        public double Hauteur { get; set; }
        public double TempInt { get; set; }
        public double TempExt { get; set; }
        public double CoefficientG { get; set; }
    }
} 