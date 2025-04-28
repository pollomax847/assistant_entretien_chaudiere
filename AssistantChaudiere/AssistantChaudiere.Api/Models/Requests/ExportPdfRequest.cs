namespace AssistantChaudiere.Api.Models.Requests
{
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