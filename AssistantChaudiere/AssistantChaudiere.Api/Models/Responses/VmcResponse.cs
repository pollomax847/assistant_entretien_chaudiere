namespace AssistantChaudiere.Api.Models.Responses
{
    public class VmcResponse
    {
        public double DebitTotal { get; set; }
        public double DebitCuisine { get; set; }
        public double DebitSalleDeBain { get; set; }
        public double DebitWc { get; set; }
        public string Message { get; set; }
    }
} 