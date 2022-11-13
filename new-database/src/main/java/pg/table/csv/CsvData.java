package pg.table.csv;

import pg.table.Arrangement;
import pg.table.Company;
import pg.table.Employment;
import pg.table.QualificationTest;
import pg.table.cv.*;
import pg.table.people.Applicant;
import pg.table.people.CompanyRepresentative;
import pg.table.people.Recruiter;
import pg.table.vacancy.Benefit;
import pg.table.vacancy.JobRequirement;
import pg.table.vacancy.Vacancy;

import java.util.List;

public interface CsvData {
    List<CsvData> tables = List.of(
            Course.dummy(), CurriculumVitae.dummy(), Education.dummy(), Experience.dummy(),
            Skill.dummy(), Applicant.dummy(), CompanyRepresentative.dummy(), Recruiter.dummy(),
            Benefit.dummy(), JobRequirement.dummy(), Vacancy.dummy(), Arrangement.dummy(),
            Company.dummy(), Employment.dummy(), QualificationTest.dummy()
    );

    String CSV_DIR = "/generated-csv/";

    default String getCsvFileName() {
        return CSV_DIR + this.getClass().getSimpleName() + ".csv";
    }

    String getColumns();

    default String getData() {
        return this.toString();
    }
}
