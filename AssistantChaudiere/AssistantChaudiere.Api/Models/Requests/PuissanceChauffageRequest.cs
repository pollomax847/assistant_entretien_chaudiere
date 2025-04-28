namespace AssistantChaudiere.Api.Models.Requests
{
    public class PuissanceChauffageRequest
    {
        public double Surface { get; set; }
        public double Hauteur { get; set; }
        public double TempInt { get; set; }
        public double TempExt { get; set; }
        public double CoefficientG { get; set; }
    }
} 