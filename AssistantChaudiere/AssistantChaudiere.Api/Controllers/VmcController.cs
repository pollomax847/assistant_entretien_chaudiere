using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using AssistantChaudiere.Api.Models.Requests;
using AssistantChaudiere.Api.Models.Responses;

namespace AssistantChaudiere.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VmcController : ControllerBase
    {
        [HttpPost("Save")]
        public IActionResult Save([FromBody] VmcRequest request)
        {
            try
            {
                // Ici, vous pourriez sauvegarder les données dans une base de données
                return Ok(new { message = "Vérification sauvegardée avec succès" });
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la sauvegarde : {ex.Message}");
            }
        }

        [HttpPost("ExportPdf")]
        public async Task<IActionResult> ExportPdf([FromBody] VmcRequest request)
        {
            try
            {
                var pdfBytes = await GeneratePdf(request);
                return File(pdfBytes, "application/pdf", "verification_vmc.pdf");
            }
            catch (Exception ex)
            {
                return BadRequest($"Erreur lors de la génération du PDF : {ex.Message}");
            }
        }

        [HttpPost("calculer")]
        public ActionResult<VmcResponse> CalculerDebit([FromBody] VmcRequest request)
        {
            try
            {
                // Calcul du débit total selon la surface
                double debitTotal = request.Surface * 0.5; // 0.5 m³/h par m²

                // Calcul des débits par pièce
                double debitCuisine = request.Cuisine ? 90 : 0; // 90 m³/h pour la cuisine
                double debitSalleDeBain = request.SalleDeBain ? 15 : 0; // 15 m³/h pour la salle de bain
                double debitWc = request.Wc ? 15 : 0; // 15 m³/h pour les WC

                // Vérification du débit minimal
                double debitMinimal = 15 * request.NombrePieces; // 15 m³/h par pièce
                if (debitTotal < debitMinimal)
                {
                    debitTotal = debitMinimal;
                }

                var response = new VmcResponse
                {
                    DebitTotal = debitTotal,
                    DebitCuisine = debitCuisine,
                    DebitSalleDeBain = debitSalleDeBain,
                    DebitWc = debitWc,
                    Message = "Calcul des débits VMC effectué avec succès"
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                return BadRequest(new VmcResponse
                {
                    Message = $"Erreur lors du calcul des débits VMC : {ex.Message}"
                });
            }
        }

        private async Task<byte[]> GeneratePdf(VmcRequest request)
        {
            using (var stream = new System.IO.MemoryStream())
            {
                using (var writer = new PdfWriter(stream))
                {
                    using (var pdf = new PdfDocument(writer))
                    {
                        var document = new Document(pdf);

                        // En-tête
                        document.Add(new Paragraph("Vérification d'installation VMC")
                            .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER)
                            .SetFontSize(20)
                            .SetBold());

                        // Données d'entrée
                        document.Add(new Paragraph("\nDonnées d'entrée :")
                            .SetBold());
                        document.Add(new Paragraph($"Type d'installation : {GetTypeVmcName(request.TypeVMC)}"));
                        document.Add(new Paragraph($"Nombre de bouches : {request.NbBouches}"));
                        document.Add(new Paragraph($"Débit total mesuré : {request.DebitMesure} m³/h"));
                        document.Add(new Paragraph($"Débit d'air : {request.DebitMS} m/s"));
                        document.Add(new Paragraph($"Modules aux fenêtres : {(request.ModulesFenetre ? "Conformes" : "Non conformes")}"));
                        document.Add(new Paragraph($"Étalonnage des portes : {(request.EtalonnagePortes ? "Vérifié" : "Non vérifié")}"));

                        // Vérifications
                        var result = CheckConformity(request);
                        document.Add(new Paragraph("\nRésultat de la vérification :")
                            .SetBold());
                        document.Add(new Paragraph($"Conformité : {(result.Conform ? "Conforme" : "Non conforme")}"));

                        if (result.Messages.Count > 0)
                        {
                            document.Add(new Paragraph("\nPoints à vérifier :")
                                .SetBold());
                            foreach (var message in result.Messages)
                            {
                                document.Add(new Paragraph($"- {message}"));
                            }
                        }

                        document.Close();
                    }
                }
                return stream.ToArray();
            }
        }

        private string GetTypeVmcName(string typeVMC)
        {
            switch (typeVMC)
            {
                case "simple_flux": return "Simple flux";
                case "sanitaire": return "Sanitaire";
                case "sekoia": return "Sekoia";
                case "vti": return "VTI";
                default: return typeVMC;
            }
        }

        private VmcResult CheckConformity(VmcRequest request)
        {
            var result = new VmcResult
            {
                Conform = true,
                Messages = new List<string>()
            };

            // Vérification du débit total
            var debitMin = GetDebitMin(request.TypeVMC) * request.NbBouches;
            var debitMax = GetDebitMax(request.TypeVMC) * request.NbBouches;

            if (request.DebitMesure < debitMin)
            {
                result.Conform = false;
                result.Messages.Add($"Le débit mesuré ({request.DebitMesure} m³/h) est inférieur au débit minimum requis ({debitMin} m³/h)");
            }
            else if (request.DebitMesure > debitMax)
            {
                result.Conform = false;
                result.Messages.Add($"Le débit mesuré ({request.DebitMesure} m³/h) est supérieur au débit maximum autorisé ({debitMax} m³/h)");
            }

            // Vérification du débit en m/s
            if (request.DebitMS < 0.8 || request.DebitMS > 2.5)
            {
                result.Conform = false;
                result.Messages.Add($"Le débit d'air ({request.DebitMS} m/s) n'est pas dans la plage optimale (0.8 - 2.5 m/s)");
            }

            // Vérification des modules aux fenêtres
            if (!request.ModulesFenetre)
            {
                result.Conform = false;
                result.Messages.Add("Les modules aux fenêtres ne sont pas conformes");
            }

            // Vérification de l'étalonnage des portes
            if (!request.EtalonnagePortes)
            {
                result.Conform = false;
                result.Messages.Add("L'étalonnage des portes n'a pas été vérifié");
            }

            return result;
        }

        private double GetDebitMin(string typeVMC)
        {
            switch (typeVMC)
            {
                case "simple_flux": return 15;
                case "sanitaire": return 20;
                case "sekoia": return 25;
                case "vti": return 30;
                default: return 0;
            }
        }

        private double GetDebitMax(string typeVMC)
        {
            switch (typeVMC)
            {
                case "simple_flux": return 30;
                case "sanitaire": return 40;
                case "sekoia": return 45;
                case "vti": return 50;
                default: return 0;
            }
        }
    }

    public class VmcRequest
    {
        public string TypeVMC { get; set; }
        public int NbBouches { get; set; }
        public double DebitMesure { get; set; }
        public double DebitMS { get; set; }
        public bool ModulesFenetre { get; set; }
        public bool EtalonnagePortes { get; set; }
        public double Surface { get; set; }
        public bool Cuisine { get; set; }
        public bool SalleDeBain { get; set; }
        public bool Wc { get; set; }
        public int NombrePieces { get; set; }
    }

    public class VmcResult
    {
        public bool Conform { get; set; }
        public List<string> Messages { get; set; }
    }
} 