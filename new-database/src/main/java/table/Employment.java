package table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import table.cv.CurriculumVitae;
import table.people.Applicant;
import table.people.CompanyRepresentative;
import table.people.Recruiter;
import table.vacancy.Vacancy;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class Employment {
    private UUID id;
    private Applicant applicant;
    private CurriculumVitae cv;
    private Arrangement arrangement;
    private Company company;
    private Vacancy vacancy;
    private Recruiter recruiter;
    private CompanyRepresentative representative;
    private QualificationTest qualificationTest;

    private Integer amountOfApplicationsForVacancy;
    private LocalDate dateOfEmployment;
    private Boolean wasInterviewDone;
    private Integer numberOfFirmEmployeesNow;
    private Boolean isQualificationTestPassed;

    private Float beginningSalary;
    private Integer arrangementMonths;
    private Integer arrangementYears;


    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s,%s,%s,%s,%d,%s,%s,%d,%s,%f,%d,%d".formatted(
                id,
                applicant.getId(),
                cv.getId(),
                arrangement.getId(),
                company.getId(),
                vacancy.getId(),
                recruiter.getId(),
                representative.getId(),
                qualificationTest.getId(),

                amountOfApplicationsForVacancy,
                dateOfEmployment.format(DateTimeFormatter.ISO_LOCAL_DATE),
                wasInterviewDone,
                numberOfFirmEmployeesNow,
                isQualificationTestPassed,

                beginningSalary,
                arrangementMonths,
                arrangementYears
        );
    }
}