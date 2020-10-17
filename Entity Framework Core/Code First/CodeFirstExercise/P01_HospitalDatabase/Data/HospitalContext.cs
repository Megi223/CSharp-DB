using Microsoft.EntityFrameworkCore;
using P01_HospitalDatabase.Data.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace P01_HospitalDatabase.Data
{
    public class HospitalContext : DbContext
    {
        public HospitalContext(DbContextOptions options) : base(options)
        {
        }

        public HospitalContext()
        {
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(@"Server=(localdb)\MSSQLLocalDB;Database=Hospital;Integrated security=true");
            }
            base.OnConfiguring(optionsBuilder);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Patient>(e =>
            {
                e.HasKey(e => e.PatientId);

                e.Property(e => e.FirstName)
                .HasMaxLength(50)
                .IsRequired()
                .IsUnicode();

                e.Property(e => e.LastName)
                .HasMaxLength(50)
                .IsRequired()
                .IsUnicode();

                e.Property(e => e.Address)
                .HasMaxLength(250)
                .IsRequired()
                .IsUnicode();

                e.Property(e => e.Email)
                .HasMaxLength(80)
                .IsRequired()
                .IsUnicode(false);
            });

            modelBuilder.Entity<Diagnose>(e =>
            {
                e.HasKey(e => e.DiagnoseId);

                e.Property(e => e.Name)
                .HasMaxLength(50)
                .IsRequired()
                .IsUnicode();

                e.Property(e => e.Comments)
                .HasMaxLength(250)
                .IsRequired(false)
                .IsUnicode();

                e.HasOne(e => e.Patient)
                .WithMany(e => e.Diagnoses)
                .HasForeignKey(e => e.PatientId);
            });

            modelBuilder.Entity<Visitation>(e => 
            {
                e.HasKey(e => e.VisitationId);

                e.HasOne(e => e.Patient)
                .WithMany(e => e.Visitations)
                .HasForeignKey(e => e.PatientId);

                e.HasOne(e => e.Doctor)
                .WithMany(e => e.Visitations)
                .HasForeignKey(e => e.DoctorId);
            });

            modelBuilder.Entity<Medicament>(e =>
            {
                e.HasKey(e => e.MedicamentId);

                e.Property(e => e.Name)
                .HasMaxLength(50)
                .IsRequired()
                .IsUnicode();
            });

            modelBuilder.Entity<PatientMedicament>(e =>
            {
                e.HasKey(p => new { p.PatientId, p.MedicamentId });

                e.HasOne(p => p.Patient)
                .WithMany(p => p.Prescriptions)
                .HasForeignKey(p => p.PatientId);

                e.HasOne(p => p.Medicament)
               .WithMany(p => p.Prescriptions)
               .HasForeignKey(p => p.MedicamentId);

            });

            modelBuilder.Entity<Doctor>(e =>
            {
                e.HasKey(e => e.DoctorId);

                e.Property(e => e.Name)
                .HasMaxLength(100)
                .IsUnicode()
                .IsRequired();

                e.Property(e => e.Specialty)
                .HasMaxLength(100)
                .IsUnicode()
                .IsRequired();
            });

        }
    }
}
