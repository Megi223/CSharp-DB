namespace BookShop
{
    using BookShop.Models;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore;
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Text;

    public class StartUp
    {
        public static void Main()
        {
            using BookShopContext db = new BookShopContext();
            //DbInitializer.ResetDatabase(db);

            //string command = Console.ReadLine();
            //int year = int.Parse(Console.ReadLine());
            //string date = Console.ReadLine();
            //string input = Console.ReadLine();
            //int length= int.Parse(Console.ReadLine());



            //string resultPOne = GetBooksByAgeRestriction(db,command);
            //string resultPTwo = GetGoldenBooks(db);
            //string resultPThree = GetBooksByPrice(db);
            //string resultPFour = GetBooksNotReleasedIn(db,year);
            //string resultPFive = GetBooksByCategory(db, input);
            //string resultPSix = GetBooksReleasedBefore(db, date);
            //string resultPSeven = GetAuthorNamesEndingIn(db, input);
            //string resultPEight = GetBookTitlesContaining(db, input);
            //string resultPNine = GetBooksByAuthor(db, input);
            //int resultPTen = CountBooks(db, length);
            //string resultPEleven = CountCopiesByAuthor(db);
            //string resultPTwelve = GetTotalProfitByCategory(db);
            //string resultPThirteen = GetMostRecentBooks(db);
            //IncreasePrices(db);
            int resultPFifteen = RemoveBooks(db);


            //Console.WriteLine($"There are {resultPTen} books with longer title than {length} symbols");

            Console.WriteLine(resultPFifteen);
        }

        //Problem 02
        public static string GetBooksByAgeRestriction(BookShopContext context, string command)
        {
            var books = context.Books
                .AsEnumerable()
                .Where(b => b.AgeRestriction.ToString().ToLower() == command.ToLower())
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToList();

            string result = string.Join(Environment.NewLine, books);
            return result;
        }

        public static string GetGoldenBooks(BookShopContext context)
        {
            var books = context.Books
                .AsEnumerable()
                .Where(b => b.EditionType.ToString() == "Gold" && b.Copies < 5000)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();
            string result = string.Join(Environment.NewLine, books);
            return result;
        }

        //Problem 03
        public static string GetBooksByPrice(BookShopContext context)
        {
            var books = context
                .Books
                .Where(b => b.Price > 40)
                .Select(b => new
                {
                    b.Title,
                    b.Price
                })
                .OrderByDescending(b => b.Price)
                .ToList();

            StringBuilder sb = new StringBuilder();

            foreach (var book in books)
            {
                sb.AppendLine($"{book.Title} - ${book.Price:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 04
        public static string GetBooksNotReleasedIn(BookShopContext context, int year)
        {
            var books = context
                .Books
                .Where(b => b.ReleaseDate.Value.Year != year)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            string result = string.Join(Environment.NewLine, books);
            return result;
        }

        //Problem 05
        public static string GetBooksByCategory(BookShopContext context, string input)
        {
            List<string> inputToList = input
                .Split(" ", StringSplitOptions.RemoveEmptyEntries)
                .ToList();

            List<string> bookTitles = new List<string>();
            
            for (int i = 0; i < inputToList.Count; i++)
            {
                string currentCategory = inputToList[i];

                var books = context
                    .BooksCategories.Where(b => b.Category.Name.ToLower() == currentCategory.ToLower())
                    .Select(b=>b.Book.Title)
                    .ToList();

                bookTitles.AddRange(books);
            }
            bookTitles=bookTitles.OrderBy(b=>b).ToList();

            string result = string.Join(Environment.NewLine, bookTitles);
            return result;
        }


        //Problem 06
        public static string GetBooksReleasedBefore(BookShopContext context, string date)
        {
            DateTime dateTime = DateTime.ParseExact(date, "dd-MM-yyyy",CultureInfo.InvariantCulture);
            var books = context
                .Books
                .Where(b => b.ReleaseDate.Value < dateTime)
                .OrderByDescending(b => b.ReleaseDate)
                .Select(b => new
                {
                    b.Title,
                    b.EditionType,
                    b.Price
                })
                .ToList();

            StringBuilder sb = new StringBuilder();
            foreach (var book in books)
            {
                sb.AppendLine($"{book.Title} - {book.EditionType} - ${book.Price:F2}");
            }
            return sb.ToString().TrimEnd();

        }

        //Problem 07
        public static string GetAuthorNamesEndingIn(BookShopContext context, string input)
        {
            var authors = context.Authors
                .Where(a => a.FirstName.EndsWith(input))
                .OrderBy(a => a.FirstName)
                .ThenBy(a => a.LastName)
                .Select(a => new
                {
                    FullName = a.FirstName + " " + a.LastName
                })
                .ToList();

            StringBuilder sb = new StringBuilder();

            foreach (var author in authors)
            {
                sb.AppendLine(author.FullName);
            }
            return sb.ToString().TrimEnd();
        }

        //Problem 08
        public static string GetBookTitlesContaining(BookShopContext context, string input)
        {
            var books = context.Books
                .Where(b => b.Title.ToLower().Contains(input.ToLower()))
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToList();

            string result = string.Join(Environment.NewLine, books);
            return result;
        }

        //Problem 09
        public static string GetBooksByAuthor(BookShopContext context, string input)
        {
            var books = context.Books
                .Where(b => b.Author.LastName.ToLower().StartsWith(input.ToLower()))
                .OrderBy(b => b.BookId)
                .Select(b => new
                {
                    b.Title,
                    AuthorName = b.Author.FirstName + " " + b.Author.LastName
                })
                .ToList();

            StringBuilder sb = new StringBuilder();

            foreach (var book in books)
            {
                sb.AppendLine($"{book.Title} ({book.AuthorName})");
            }
            return sb.ToString().TrimEnd();
        }

        //Problem 10
        public static int CountBooks(BookShopContext context, int lengthCheck)
        {
            var count = context.Books
                .AsEnumerable()
                .Where(b => b.Title.Count() > lengthCheck)
                .Count();

            return count;
        }

        //Problem 11

        public static string CountCopiesByAuthor(BookShopContext context)
        {
            var authorsWithCopies = context
                .Authors
                .Select(b => new
                {
                    fullName = b.FirstName + " " + b.LastName,
                    count = b.Books.Select(bk => bk.Copies).Sum()
                })
                .OrderByDescending(b=>b.count)
                .ToList();

            StringBuilder sb = new StringBuilder();
            foreach (var a in authorsWithCopies)
            {
                sb.AppendLine($"{a.fullName} - {a.count}");
            }
            return sb.ToString().TrimEnd();
        }

        //Problem 12
        public static string GetTotalProfitByCategory(BookShopContext context)
        {
            var profitByCat = context
                .Categories
                .Select(c => new
                {
                    c.Name,
                    TotalProfit = c
                            .CategoryBooks
                            .Select(b => new
                            {
                                Profit = b.Book.Copies * b.Book.Price
                            })
                            .Sum(c => c.Profit)
                })
                .OrderByDescending(c => c.TotalProfit)
                .ThenBy(c => c.Name)
                .ToList();

            StringBuilder sb = new StringBuilder();

            foreach (var p in profitByCat)
            {
                sb.AppendLine($"{p.Name} ${p.TotalProfit:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 13
        public static string GetMostRecentBooks(BookShopContext context)
        {
            var mostRecentBooks = context
                                .Categories
                                .Select(c => new
                                {
                                    c.Name,
                                    books = c.CategoryBooks
                                    .OrderByDescending(b => b.Book.ReleaseDate)
                                    .Select(b => new
                                    {
                                        BookTitle = b.Book.Title,
                                        ReleaseYear = b.Book.ReleaseDate.Value.Year
                                    }).Take(3)
                                    .ToList()
                                })
                                .OrderBy(c => c.Name)
                                .ToList();

            StringBuilder sb = new StringBuilder();

            foreach (var c in mostRecentBooks)
            {
                sb.AppendLine($"--{c.Name}");
                foreach (var b in c.books)
                {
                    sb.AppendLine($"{b.BookTitle} ({b.ReleaseYear})");
                }
            }

            return sb.ToString().TrimEnd();

        }

        //Problem 14
        public static void IncreasePrices(BookShopContext context)
        {
            var books = context
                .Books
                .Where(b => b.ReleaseDate.Value.Year < 2010)
                .ToList();

            foreach (var b in books)
            {
                b.Price += 5;
            }
            context.SaveChanges();
        }

        //Problem 15
        public static int RemoveBooks(BookShopContext context)
        {
            var books = context
                .Books
                .Where(b => b.Copies < 4200)
                .ToList();

            var removedBooks = books.Count();

            context.Books.RemoveRange(books);

            context.SaveChanges();

            return removedBooks;
        }

    }
}
