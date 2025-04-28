using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AssistantChaudiere.Api.Models
{
    public class Entretien
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ChaudiereId { get; set; }

        [ForeignKey("ChaudiereId")]
        public Chaudiere Chaudiere { get; set; }

        [Required]
        public DateTime DateEntretien { get; set; }

        [Required]
        [StringLength(500)]
        public string Description { get; set; }

        [Required]
        public string Technicien { get; set; }

        public decimal? Cout { get; set; }

        public string? Observations { get; set; }

        public bool EstEffectue { get; set; }

        public DateTime? DateProchainEntretien { get; set; }
    }
} 