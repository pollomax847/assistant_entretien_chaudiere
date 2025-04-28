using System;
using System.ComponentModel.DataAnnotations;

namespace AssistantChaudiere.Web.Models
{
    public class Entretien
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "La chaudière est requise")]
        public int ChaudiereId { get; set; }

        public Chaudiere Chaudiere { get; set; }

        [Required(ErrorMessage = "La date d'entretien est requise")]
        [DataType(DataType.Date)]
        public DateTime DateEntretien { get; set; }

        [Required(ErrorMessage = "La description est requise")]
        [StringLength(500, ErrorMessage = "La description ne peut pas dépasser 500 caractères")]
        public string Description { get; set; }

        [Required(ErrorMessage = "Le technicien est requis")]
        [StringLength(100, ErrorMessage = "Le nom du technicien ne peut pas dépasser 100 caractères")]
        public string Technicien { get; set; }

        [Range(0, double.MaxValue, ErrorMessage = "Le coût doit être positif")]
        public decimal? Cout { get; set; }

        public string Observations { get; set; }

        public bool EstEffectue { get; set; }

        [DataType(DataType.Date)]
        public DateTime? DateProchainEntretien { get; set; }
    }
} 