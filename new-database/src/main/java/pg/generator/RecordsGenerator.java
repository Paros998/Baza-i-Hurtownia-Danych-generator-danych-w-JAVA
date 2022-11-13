package pg.generator;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import com.thedeanda.lorem.Lorem;
import com.thedeanda.lorem.LoremIpsum;
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
import pg.utils.CsvWriter;
import pg.utils.Data;

import java.time.Clock;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.function.Function;

@Slf4j
@AllArgsConstructor(staticName = "of")
public class RecordsGenerator {
    private static final Random rand = RandomUtil.random;
    private static final Clock clock = RandomUtil.clock;
    private static final DateTimeFormatter format1 = DateTimeFormatter.ofPattern("M/d/yyyy");
    private static final DateTimeFormatter format2 = DateTimeFormatter.ofPattern("MM/dd/yyyy");
    private final Data data;
    private final Lorem lorem = LoremIpsum.getInstance();

    private static <T, R> List<R> applyFunction(final Function<T, R> function, final T argument, final Integer maxRandom) {
        int numberOfExecutions = RandomUtil.intBetween(1, maxRandom);
        int currentExecution = 1;

        List<R> result = new ArrayList<>();

        do {
            result.add(function.apply(argument));
            currentExecution++;
        } while (currentExecution <= numberOfExecutions);

        return result;
    }

    private static <T> T getRandomObject(final List<T> data) {
        return data.get(rand.nextInt(data.size()));
    }

    private static LocalDate tryParse(final String date) {
        try {
            return LocalDate.parse(date, format1);
        } catch (DateTimeParseException e) {
            return LocalDate.parse(date, format2);
        }
    }

    public void generateFacts(final Integer numberOfFacts) {
        int currentFact = 1;
        log.info("Starting generating records - 0%");
        do {
            CsvWriter.writeRecordToFile(generateEmployment());

            currentFact -= -1; // XD (<:
            if ((currentFact - 1) % 250 == 0)
                log.info("Generated %d records - %f".formatted((currentFact - 1), (currentFact - 1) * 100.0f / numberOfFacts) + "%");
        } while (currentFact <= numberOfFacts);

        log.info("Generating records completed - 100%");
    }

    private Employment generateEmployment() {
        var employmentData = getRandomObject(data.getEmployments());

        var arrangement = generateArrangement();

        boolean isPeriodContract = arrangement.getTypeOfArrangement().equals("trial period contract");

        return Employment.builder()
                .applicant(generateApplicant())
                .cv(generateCurriculumVitae())
                .arrangement(arrangement)
                .company(generateCompany())
                .vacancy(generateVacancy())
                .recruiter(generateRecruiter())
                .representative(generateCompanyRepresentative())
                .qualificationTest(generateQualificationTest())

                .amountOfApplicationsForVacancy(employmentData.getAmountOfApplicationsForVacancy())
                .dateOfEmployment(LocalDate.now(clock).minusMonths(isPeriodContract ? RandomUtil.intBetween(0, 6) :
                        RandomUtil.intBetween(2, 48)))
                .wasInterviewDone(RandomUtil.getBoolean())
                .numberOfFirmEmployeesNow(employmentData.getNumberOfFirmEmployeesNow())
                .isQualificationTestPassed(RandomUtil.getBoolean())

                .beginningSalary(employmentData.getBeginningSalary())
                .validTo(LocalDate.now(clock).plusMonths(isPeriodContract ? 3 : employmentData.getArrangementMonths()))
                .build();
    }

    private Applicant generateApplicant() {
        var firstName = getRandomObject(data.getNames());
        var lastName = getRandomObject(data.getNames());
        var personalData = getRandomObject(data.getPersonalData());

        final var result = Applicant.builder()
                .id(UUID.randomUUID())
                .firstName(firstName.getFirstName())
                .lastName(lastName.getLastName())
                .birthDate(tryParse(personalData.getBirthDate()))
                .personalNumber(personalData.getPersonalNumber())
                .yearsOfExperience(RandomUtil.intBetween(1, 20))

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private CurriculumVitae generateCurriculumVitae() {
        var cvData = getRandomObject(data.getAddresses());

        final var result = CurriculumVitae.builder()
                .id(UUID.randomUUID())
                .city(cvData.getCity())
                .voivodeship(cvData.getVoivodeship())
                .postalCode(cvData.getPostalCode())
                .country(cvData.getCountry())
                .street(cvData.getStreet() + ";" + RandomUtil.intBetween(1, 60))

                .build();

        result.setExperiences(applyFunction(this::generateExperience, result, 4));
        result.setEducations(applyFunction(this::generateEducation, result, 3));
        result.setSkills(applyFunction(this::generateSkill, result, 6));
        result.setCourses(applyFunction(this::generateCourse, result, 4));

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Company generateCompany() {
        var company = getRandomObject(data.getCompanies());

        final var result = Company.builder()
                .id(UUID.randomUUID())
                .companyName(company.getCompanyName())
                .address(company.getAddress())
                .email(company.getEmail())
                .identificationNumber(company.getIdentificationNumber())

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Recruiter generateRecruiter() {
        var firstName = getRandomObject(data.getNames());
        var lastName = getRandomObject(data.getNames());
        var email = getRandomObject(data.getEmails());
        var phoneNumber = getRandomObject(data.getPhoneNumbers());

        final var result = Recruiter.builder()
                .id(UUID.randomUUID())
                .firstName(firstName.getFirstName())
                .lastName(lastName.getLastName())
                .email(email)
                .phoneNumber(phoneNumber)

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private CompanyRepresentative generateCompanyRepresentative() {
        var firstName = getRandomObject(data.getNames());
        var lastName = getRandomObject(data.getNames());
        var role = getRandomObject(data.getRoles());

        final var result = CompanyRepresentative.builder()
                .id(UUID.randomUUID())
                .firstName(firstName.getFirstName())
                .lastName(lastName.getLastName())
                .role(role)

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Vacancy generateVacancy() {
        var vacancyData = getRandomObject(data.getVacancies());
        var schedule = getRandomObject(data.getJobSchedules());

        final var result = Vacancy.builder()
                .id(UUID.randomUUID())
                .name(vacancyData.getName())
                .sectorName(vacancyData.getSectorName())
                .jobDescription(lorem.getWords(15, 40))
                .lowestSalaryGap(vacancyData.getLowestSalaryGap())
                .highestSalaryGap(vacancyData.getHighestSalaryGap())
                .levelOfAdvancement(vacancyData.getLevelOfAdvancement())
                .workSchedule(schedule)

                .build();

        result.setRequirements(applyFunction(this::generateJobRequirement, result, 6));
        result.setBenefits(applyFunction(this::generateBenefit, result, 4));

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Arrangement generateArrangement() {
        var responsibilities = data.getResponsibilities();
        var requirements = data.getRequirements();
        var type = getRandomObject(data.getWorkArrangements());

        final var result = Arrangement.builder()
                .id(UUID.randomUUID())
                .responsibilities(applyFunction(RecordsGenerator::getRandomObject, responsibilities, 12))
                .requirements(applyFunction(RecordsGenerator::getRandomObject, requirements, 9))
                .typeOfArrangement(type)

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private QualificationTest generateQualificationTest() {
        var test = getRandomObject(data.getTests());

        final var result = QualificationTest.builder()
                .id(UUID.randomUUID())
                .name(test.getName())
                .difficultyLevel(test.getDifficultyLevel())
                .description(lorem.getWords(45, 100))

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private JobRequirement generateJobRequirement(final Vacancy vacancy) {
        var requirement = getRandomObject(data.getJobRequirements());

        final var result = JobRequirement.builder()
                .id(UUID.randomUUID())
                .name(requirement.getName())
                .experienceLevel(requirement.getExperienceLevel())
                .description(lorem.getWords(8, 18))
                .vacancy(vacancy)

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Benefit generateBenefit(final Vacancy vacancy) {
        var benefit = getRandomObject(data.getBenefits());

        final var result = Benefit.builder()
                .id(UUID.randomUUID())
                .vacancy(vacancy)
                .description(lorem.getWords(10, 25))
                .name(benefit)
                .amount(rand.nextFloat(50f, 500f))

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Experience generateExperience(final CurriculumVitae cv) {
        var experience = getRandomObject(data.getExperiences());
        var responsibilities = data.getResponsibilities();

        final var result = Experience.builder()
                .id(UUID.randomUUID())
                .cv(cv)
                .since(tryParse(experience.getSince()))
                .to(tryParse(experience.getTo()))
                .responsibilities(applyFunction(RecordsGenerator::getRandomObject, responsibilities, 4))
                .vacancy(experience.getVacancy())
                .companyName(experience.getCompanyName())

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Education generateEducation(final CurriculumVitae cv) {
        var education = getRandomObject(data.getEducations());

        final var result = Education.builder()
                .id(UUID.randomUUID())
                .cv(cv)
                .since(tryParse(education.getSince()))
                .to(tryParse(education.getTo()))
                .description(lorem.getWords(20, 40))
                .schoolName(education.getSchoolName())

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Skill generateSkill(final CurriculumVitae cv) {
        var skill = getRandomObject(data.getSkills());

        final var result = Skill.builder()
                .id(UUID.randomUUID())
                .cv(cv)
                .name(skill.getName())
                .level(skill.getLevel())

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }

    private Course generateCourse(final CurriculumVitae cv) {
        var course = getRandomObject(data.getCourses());

        final var result = Course.builder()
                .id(UUID.randomUUID())
                .cv(cv)
                .date(tryParse(course.getDate()))
                .validTo(tryParse(course.getValidTo()))
                .name(course.getName())
                .description(lorem.getWords(20, 40))

                .build();

        CsvWriter.writeRecordToFile(result);

        return result;
    }
}