using System;
using System.ComponentModel.DataAnnotations;

namespace AssistantChaudiere.Web.Models
{
    public class Chaudiere
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Le modèle est requis")]
        [StringLength(100, ErrorMessage = "Le modèle ne peut pas dépasser 100 caractères")]
        public string Modele { get; set; }

        [Required(ErrorMessage = "La marque est requise")]
        [StringLength(100, ErrorMessage = "La marque ne peut pas dépasser 100 caractères")]
        public string Marque { get; set; }

        [Required(ErrorMessage = "La date d'installation est requise")]
        [DataType(DataType.Date)]
        public DateTime DateInstallation { get; set; }

        [Required(ErrorMessage = "La puissance est requise")]
        [Range(0, double.MaxValue, ErrorMessage = "La puissance doit être positive")]
        public decimal Puissance { get; set; }

        [Required(ErrorMessage = "Le type d'énergie est requis")]
        public string TypeEnergie { get; set; }

        public string NumeroSerie { get; set; }

        public string Notes { get; set; }

        [DataType(DataType.Date)]
        public DateTime? DernierEntretien { get; set; }

        [DataType(DataType.Date)]
        public DateTime? ProchainEntretien { get; set; }
    }
} 