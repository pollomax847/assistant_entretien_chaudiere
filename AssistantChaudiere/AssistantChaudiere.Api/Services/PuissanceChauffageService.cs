using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using AssistantChaudiere.Api.Models.Requests;

namespace AssistantChaudiere.Api.Services
{
    public class PuissanceChauffageService
    {
        public async Task<byte[]> GeneratePdf(PuissanceChauffageRequest request)
        {
            using (var stream = new System.IO.MemoryStream())
            {
                using (var writer = new PdfWriter(stream))
                {
                    using (var pdf = new PdfDocument(writer))
                    {
                        var document = new Document(pdf);

                        // En-tête
                        document.Add(new Paragraph("Calcul de puissance de chauffage")
                            .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER)
                            .SetFontSize(20)
                            .SetBold());

                        // Données d'entrée
                        document.Add(new Paragraph("\nDonnées d'entrée :")
                            .SetBold());
                        document.Add(new Paragraph($"Surface : {request.Surface} m²"));
                        document.Add(new Paragraph($"Hauteur sous plafond : {request.Hauteur} m"));
                        document.Add(new Paragraph($"Température intérieure : {request.TempInt}°C"));
                        document.Add(new Paragraph($"Température extérieure de base : {request.TempExt}°C"));
                        document.Add(new Paragraph($"Coefficient G : {request.CoefficientG}"));

                        // Calcul
                        var volume = request.Surface * request.Hauteur;
                        var deltaT = request.TempInt - request.TempExt;
                        var puissance = volume * request.CoefficientG * deltaT;

                        // Résultat
                        document.Add(new Paragraph("\nRésultat :")
                            .SetBold());
                        document.Add(new Paragraph($"Puissance nécessaire : {puissance:F2} W"));

                        // Notes
                        document.Add(new Paragraph("\nNotes :")
                            .SetBold());
                        document.Add(new Paragraph("Ce calcul est basé sur la méthode de calcul des déperditions thermiques."));
                        document.Add(new Paragraph("La puissance calculée est indicative et doit être validée par un professionnel."));

                        document.Close();
                    }
                }
                return stream.ToArray();
            }
        }
    }
} 