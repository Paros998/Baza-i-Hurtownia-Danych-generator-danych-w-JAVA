package pg.table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;
import pg.table.cv.CurriculumVitae;
import pg.table.people.Applicant;
import pg.table.people.CompanyRepresentative;
import pg.table.people.Recruiter;
import pg.table.vacancy.Vacancy;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Data
@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Builder
public class Employment implements CsvData {
    public static final String TABLE = "Zatrudnienie";
    public static final String COLUMNS = "aplikant_id,cv_id,umowa_id,firma_id,stanowisko_id,rekruter_id"
            + ",reprezentant_id,test_id,ilosc_aplikacji_na_stan,data_zatrudnienia,rozmowa_kwal_przeprowadzona"
            + ",liczba_prac_firmy,zdany_test_kwal,stawka_pocz,waznosc_umowy";
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
    private LocalDate validTo;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s,%s,%s,%d,%s,%s,%d,%s,%f.2,%s".formatted(
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
                validTo.format(DateTimeFormatter.ISO_LOCAL_DATE)
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}