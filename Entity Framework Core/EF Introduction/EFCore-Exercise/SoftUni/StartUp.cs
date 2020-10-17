
using SoftUni.Data;
using SoftUni.Models;
using System;
using System.Globalization;
using System.Linq;
using System.Text;

namespace SoftUni
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            SoftUniContext softUniContext = new SoftUniContext();

            string resultPThree = GetEmployeesFullInformation(softUniContext);
            string resultPFour = GetEmployeesWithSalaryOver50000(softUniContext);
            string resultPFive = GetEmployeesFromResearchAndDevelopment(softUniContext);
            string resultPSix = AddNewAddressToEmployee(softUniContext);
            string resultPSeven = GetEmployeesInPeriod(softUniContext);
            string resultPEight = GetAddressesByTown(softUniContext);
            string resultPNine = GetEmployee147(softUniContext);
            string resultPTen = GetDepartmentsWithMoreThan5Employees(softUniContext);
            string resultPEleven = GetLatestProjects(softUniContext);
            string resultPTwelve = IncreaseSalaries(softUniContext);
            string resultPThirteen = GetEmployeesByFirstNameStartingWithSa(softUniContext);
            string resultPFourteen = DeleteProjectById(softUniContext);
            string resultPFifteen = RemoveTown(softUniContext);

            Console.WriteLine(resultPFifteen);
        }

        //P03
        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            var result = new StringBuilder();

            var employees = context.Employees.Select(e =>
                new
                {
                    e.EmployeeId,
                    e.FirstName,
                    e.MiddleName,
                    e.LastName,
                    e.JobTitle,
                    e.Salary
                })
                .OrderBy(e => e.EmployeeId)
                .ToList();

            foreach (var e in employees)
            {
                result.AppendLine($"{e.FirstName} {e.LastName} {e.MiddleName} {e.JobTitle} {e.Salary:F2}");
            }

            return result.ToString().TrimEnd();
        }

        //P04
        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {
            var result = new StringBuilder();

            var employees = context.Employees.Select(e =>
                new
                {
                    e.FirstName,
                    e.Salary
                })
                .Where(e => e.Salary > 50000)
                .OrderBy(e=>e.FirstName)
                .ToList();

            foreach (var e in employees)
            {
                result.AppendLine($"{e.FirstName} - {e.Salary:F2}");
            }

            return result.ToString().TrimEnd();
        }

        //P05
        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {
            var result = new StringBuilder();

            var employees = context.Employees
                .Where(e => e.Department.Name == "Research and Development")
                .Select(e =>
                new
                {
                    e.FirstName,
                    e.LastName,
                    e.Department.Name,
                    e.Salary
                })
                .OrderBy(e => e.Salary)
                .ThenByDescending(e => e.FirstName)
                .ToList();

            foreach (var e in employees)
            {
                result.AppendLine($"{e.FirstName} {e.LastName} from Research and Development - ${e.Salary:F2}");
            }

            return result.ToString().TrimEnd();
        }

        //P06
        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            Address newAddress = new Address
            {
                AddressText= "Vitoshka 15",
                TownId=4
            };

            var employeeNakov = context.Employees.FirstOrDefault(e => e.LastName == "Nakov");

            newAddress.Employees.Add(employeeNakov);

            employeeNakov.Address = newAddress;

            context.SaveChanges();

            var addresses = context.Employees.Select(e =>
                        new
                        {
                            e.Address.AddressId,
                            e.Address.AddressText
                        })
                .OrderByDescending(e => e.AddressId)
                .Take(10)
                .ToList();

            foreach (var a in addresses)
            {
                sb.AppendLine(a.AddressText);
            }

            return sb.ToString().TrimEnd();
                
        }

        //P07

        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context.Employees
                .Where(e => e.EmployeesProjects
                        .Any(ep => ep.Project.StartDate.Year >= 2001 &&
                                ep.Project.StartDate.Year <= 2003
                       ))
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    ManagerFirstName = e.Manager.FirstName,
                    ManagerLastName = e.Manager.LastName,
                    Projects = e.EmployeesProjects.Select(ep => new
                    {
                        ProjectName = ep.Project.Name,
                        StartDate = ep.Project.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture),
                        EndDate = ep.Project.EndDate.HasValue ? ep.Project.EndDate.Value.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture) : "not finished"
                    }).ToList()
                })
                .Take(10)
                .ToList();

            foreach (var e in employees)
            {
                sb.AppendLine($"{e.FirstName} {e.LastName} - Manager: {e.ManagerFirstName} {e.ManagerLastName}");
                foreach (var p in e.Projects)
                {
                    sb.AppendLine($"--{p.ProjectName} - {p.StartDate} - {p.EndDate}");
                }
                    
            }

            return sb.ToString().TrimEnd();
        }

        //P08

        public static string GetAddressesByTown(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var addresses = context.Addresses.Select(a => new
            {
                EmployeeCount = a.Employees.Count,
                TownName = a.Town.Name,
                a.AddressText
            })
            .OrderByDescending(a => a.EmployeeCount)
            .ThenBy(a => a.TownName)
            .ThenBy(a => a.AddressText)
            .Take(10)
            .ToList();

            foreach (var a in addresses)
            {
                sb.AppendLine($"{a.AddressText}, {a.TownName} - {a.EmployeeCount} employees");
            }

            return sb.ToString().TrimEnd();
        }

        //P09
        public static string GetEmployee147(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employee = context.Employees
                .Select(e => new
                {
                    e.EmployeeId,
                    e.FirstName,
                    e.LastName,
                    e.JobTitle,
                    Projects = e.EmployeesProjects.Select(ep => new
                    {
                        ProjectName = ep.Project.Name,
                    }).OrderBy(p=>p.ProjectName).ToList()
                })
                .FirstOrDefault(e => e.EmployeeId == 147);
            sb.AppendLine($"{employee.FirstName} {employee.LastName} - {employee.JobTitle}");
            foreach (var p in employee.Projects)
            {
                sb.AppendLine(p.ProjectName);
            }

            return sb.ToString().TrimEnd();
        }

        //P10
        public static string GetDepartmentsWithMoreThan5Employees(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var departments = context.Departments
                .Where(e => e.Employees.Count > 5)
                .OrderBy(d => d.Employees.Count)
                .ThenBy(d => d.Name)
                .Select(d => new
                {
                    d.Name,
                    ManagerFirstName = d.Manager.FirstName,
                    ManagerLastName = d.Manager.LastName,
                    Employees = d.Employees.Select(e => new
                    {
                        e.FirstName,
                        e.LastName,
                        e.JobTitle
                    }).OrderBy(e => e.FirstName).ThenBy(e => e.LastName).ToList()
                })
                .ToList();

            foreach (var d in departments)
            {
                sb.AppendLine($"{d.Name} - {d.ManagerFirstName} {d.ManagerLastName}");
                foreach (var e in d.Employees)
                {
                    sb.AppendLine($"{e.FirstName} {e.LastName} - {e.JobTitle}");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //P11
        public static string GetLatestProjects(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var projects = context.Projects.OrderByDescending(p => p.StartDate).Select(p => new
            {
                p.Name,
                p.Description,
                p.StartDate
            })
            .Take(10)
            .OrderBy(p => p.Name)
            .ToList();

            foreach (var p in projects)
            {
                sb.AppendLine(p.Name)
                    .AppendLine(p.Description)
                    .AppendLine(p.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture));
            }

            return sb.ToString().TrimEnd();       
        }

        //P12
        public static string IncreaseSalaries(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context.Employees
                .Where(e => e.Department.Name == "Engineering" || e.Department.Name == "Tool Design" ||
                          e.Department.Name == "Marketing" || e.Department.Name == "Information Services")
                .OrderBy(e=>e.FirstName)
                .ThenBy(e=>e.LastName)
                .ToList();

            
            foreach (var employee in employees)
            {
                employee.Salary += employee.Salary * 0.12M;
            }

            context.SaveChanges();

            foreach (var e in employees)
            {
                sb.AppendLine($"{e.FirstName} {e.LastName} (${e.Salary:F2})");
            }

            return sb.ToString().TrimEnd();
        }

        //P13
        public static string GetEmployeesByFirstNameStartingWithSa(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees = context.Employees.Where(e => e.FirstName.StartsWith("Sa")).Select(e => new
            {
                e.FirstName,
                e.LastName,
                e.JobTitle,
                e.Salary
            }).OrderBy(e => e.FirstName).ThenBy(e => e.LastName).ToList();

            foreach (var e in employees)
            {
                sb.AppendLine($"{e.FirstName} {e.LastName} - {e.JobTitle} - (${e.Salary:F2})");
            }

            return sb.ToString().TrimEnd();
        }

        //P14
        public static string DeleteProjectById(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var projectWithId2 = context.Projects.FirstOrDefault(p => p.ProjectId == 2);
            var employeesProjects = context.EmployeesProjects.Where(p => p.ProjectId == 2).ToList();

            foreach (var ep in employeesProjects)
            {
                context.EmployeesProjects.Remove(ep);
            }
            context.Projects.Remove(projectWithId2);
            context.SaveChanges();
            var projectsToReturn = context.Projects.Take(10).ToList();
            foreach (var p in projectsToReturn)
            {
                sb.AppendLine(p.Name);
            }
            return sb.ToString().TrimEnd();
        }

        //P15
        public static string RemoveTown(SoftUniContext context)
        {
            var townToDelete = context.Towns.First(t => t.Name == "Seattle");

            var addressesToDel = context.Addresses.Where(a => a.Town.TownId == townToDelete.TownId);

            int addressesCount = addressesToDel.Count();

            var employeesOnDeletedAddresses = context.Employees
                .Where(e => addressesToDel.Any(a => a.AddressId == e.AddressId));

            foreach (var e in employeesOnDeletedAddresses)
            {
                e.AddressId = null;
            }

            foreach (var a in addressesToDel)
            {
                context.Addresses.Remove(a);
            }

            context.Towns.Remove(townToDelete);

            context.SaveChanges();

            return $"{addressesCount} addresses in Seattle were deleted";
        }



    }
}
