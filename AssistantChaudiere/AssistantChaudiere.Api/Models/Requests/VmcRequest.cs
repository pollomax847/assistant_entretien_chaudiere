namespace AssistantChaudiere.Api.Models.Requests
{
    public class VmcRequest
    {
        public double Surface { get; set; }
        public int NombrePieces { get; set; }
        public bool Cuisine { get; set; }
        public bool SalleDeBain { get; set; }
        public bool Wc { get; set; }
    }
} 