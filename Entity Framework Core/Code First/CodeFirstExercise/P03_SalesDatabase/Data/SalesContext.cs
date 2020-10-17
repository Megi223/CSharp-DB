using Microsoft.EntityFrameworkCore;
using P03_SalesDatabase.Data.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace P03_SalesDatabase.Data
{
    public class SalesContext : DbContext
    {
        public SalesContext(DbContextOptions options) : base(options)
        {
        }

        public SalesContext()
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(@"Server=(localdb)\MSSQLLocalDB;Database=Sales;Integrated security=true");
            }
            base.OnConfiguring(optionsBuilder);
        }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Sale> Sales { get; set; }
        public DbSet<Store> Stores { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Customer>(e =>
            {
                e.HasKey(e => e.CustomerId);

                e.Property(e => e.Name)
                .HasMaxLength(100)
                .IsRequired()
                .IsUnicode();

                e.Property(e => e.Email)
                .HasMaxLength(80)
                .IsRequired()
                .IsUnicode(false);
            });

            modelBuilder.Entity<Product>(e =>
            {
                e.HasKey(e => e.ProductId);

                e.Property(e => e.Name)
                .HasMaxLength(50)
                .IsRequired()
                .IsUnicode();

                e.Property(e => e.Description)
                .HasMaxLength(250)
                .HasDefaultValue("No description");

            });

            modelBuilder.Entity<Product>(e =>
            {
                e.HasKey(e => e.ProductId);

                e.Property(e => e.Name)
                .HasMaxLength(50)
                .IsRequired()
                .IsUnicode();

            });

            modelBuilder.Entity<Store>(e =>
            {
                e.HasKey(e => e.StoreId);

                e.Property(e => e.Name)
                .HasMaxLength(80)
                .IsRequired()
                .IsUnicode();

            });

            modelBuilder.Entity<Sale>(e =>
            {
                e.HasKey(e => e.SaleId);

                e.Property(e => e.Date)
                .HasDefaultValueSql("GETDATE()");

                e.HasOne(s => s.Product)
                .WithMany(p => p.Sales)
                .HasForeignKey(s => s.ProductId)
                .OnDelete(DeleteBehavior.Restrict);

                e.HasOne(s => s.Store)
                .WithMany(st => st.Sales)
                .HasForeignKey(s => s.StoreId)
                .OnDelete(DeleteBehavior.Restrict);

                e.HasOne(s => s.Customer)
                .WithMany(c => c.Sales)
                .HasForeignKey(s => s.CustomerId)
                .OnDelete(DeleteBehavior.Restrict);

            });
        }
    }
}
