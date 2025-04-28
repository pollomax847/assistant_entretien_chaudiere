using Microsoft.EntityFrameworkCore;
using AssistantChaudiere.Api.Models;

namespace AssistantChaudiere.Api.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Chaudiere> Chaudieres { get; set; }
        public DbSet<Entretien> Entretiens { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Chaudiere>()
                .HasMany(c => c.Entretiens)
                .WithOne(e => e.Chaudiere)
                .HasForeignKey(e => e.ChaudiereId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
} 