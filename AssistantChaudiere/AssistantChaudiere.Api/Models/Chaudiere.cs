using System;
using System.ComponentModel.DataAnnotations;

namespace AssistantChaudiere.Api.Models
{
    public class Chaudiere
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Modele { get; set; }

        [Required]
        [StringLength(100)]
        public string Marque { get; set; }

        [Required]
        public DateTime DateInstallation { get; set; }

        [Required]
        public decimal Puissance { get; set; }

        [Required]
        public string TypeEnergie { get; set; }

        public string? NumeroSerie { get; set; }

        public string? Notes { get; set; }

        public DateTime? DernierEntretien { get; set; }

        public DateTime? ProchainEntretien { get; set; }
    }
} 