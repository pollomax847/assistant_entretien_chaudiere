using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.IO.Image;
using AssistantChaudiere.Api.Models.Requests;

namespace AssistantChaudiere.Api.Services
{
    public class PdfService
    {
        public async Task<byte[]> GeneratePdf(ExportPdfRequest request, bool includeSignature)
        {
            using (var stream = new MemoryStream())
            {
                using (var writer = new PdfWriter(stream))
                {
                    using (var pdf = new PdfDocument(writer))
                    {
                        var document = new Document(pdf);

                        // En-tête
                        document.Add(new Paragraph($"Rapport d'intervention - {request.ClientName}")
                            .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER)
                            .SetFontSize(20)
                            .SetBold());

                        // Informations client
                        document.Add(new Paragraph("Informations client :")
                            .SetBold());
                        document.Add(new Paragraph($"Nom : {request.ClientName}"));
                        document.Add(new Paragraph($"Adresse : {request.ClientAddress}"));

                        // Informations intervention
                        document.Add(new Paragraph("\nInformations intervention :")
                            .SetBold());
                        document.Add(new Paragraph($"Date : {request.InterventionDate}"));
                        document.Add(new Paragraph($"Type : {request.InterventionType}"));

                        // Modules inclus
                        if (request.Modules != null && request.Modules.Count > 0)
                        {
                            document.Add(new Paragraph("\nModules inclus :")
                                .SetBold());
                            foreach (var module in request.Modules)
                            {
                                document.Add(new Paragraph($"- {module}"));
                            }
                        }

                        // Observations
                        if (!string.IsNullOrEmpty(request.Observations))
                        {
                            document.Add(new Paragraph("\nObservations :")
                                .SetBold());
                            document.Add(new Paragraph(request.Observations));
                        }

                        // Signature
                        if (includeSignature && !string.IsNullOrEmpty(request.Signature))
                        {
                            document.Add(new Paragraph("\nSignature :")
                                .SetBold());
                            
                            var signatureBytes = Convert.FromBase64String(request.Signature.Split(',')[1]);
                            var signatureImage = ImageDataFactory.Create(signatureBytes);
                            document.Add(new Image(signatureImage).SetWidth(200));
                        }

                        document.Close();
                    }
                }
                return stream.ToArray();
            }
        }
    }
} 