using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.IO.Image;
using System.Text.Json;
using AssistantChaudiere.Api.Models.Requests;
using AssistantChaudiere.Api.Services;

namespace AssistantChaudiere.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ExportPdfController : ControllerBase
    {
        private readonly PdfService _pdfService;

        public ExportPdfController(PdfService pdfService)
        {
            _pdfService = pdfService;
        }

        [HttpPost("Preview")]
        public async Task<IActionResult> Preview([FromBody] ExportPdfRequest request)
        {
            try
            {
                var pdfBytes = await _pdfService.GeneratePdf(request, false);
                return File(pdfBytes, "application/pdf");
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la prévisualisation : {ex.Message}");
            }
        }

        [HttpPost("Generate")]
        public async Task<IActionResult> Generate([FromBody] ExportPdfRequest request)
        {
            try
            {
                var pdfBytes = await _pdfService.GeneratePdf(request, true);
                return File(pdfBytes, "application/pdf", $"rapport_{request.ClientName}_{request.InterventionDate}.pdf");
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la génération du PDF : {ex.Message}");
            }
        }
    }

    public class ExportPdfRequest
    {
        public string ClientName { get; set; }
        public string ClientAddress { get; set; }
        public string InterventionDate { get; set; }
        public string InterventionType { get; set; }
        public List<string> Modules { get; set; }
        public string Observations { get; set; }
        public string Signature { get; set; }
    }
} 