// The 'kyc_on_aleo' program.
program kyc_on_aleo.aleo {

    struct IndividualInfo {
        ref_id: field,
        first: field,
        middle: field,
        last: field,
        dob_day: u32,
        dob_month: u32,
        dob_year: u32,
        nationality: field,
        national_ref_id: field,
        created_at: field,
    }

    struct ContactDetails {
        ref_id: field,
        res_address_1: field,
        res_address_2: field,
        res_address_3: field,
        res_state: field,
        res_country: field,
        mail_address_1: field,
        mail_address_2: field,
        mail_address_3: field,
        mail_state: field,
        mail_country: field,
        email: field,
        email_domain: field,
        alt_email: field,
        alt_email_domain: field,
        phone_code: u32,
        area_code: u32,
        phone: u32,
    }

    struct ProfessionalInfo {
        ref_id: field,
        occupation: field,
        employer_1: field,
        employer_2: field,
        employer_type: field,
        emp_address_1: field,
        emp_address_2: field,
        emp_address_3: field,
        emp_state: field,
        emp_country: field,
    }

    struct FinancialProfile {
        ref_id: field,
        annual_income: u64,
        income_source: field,
        funds: u64,
        fund_source: field,
        wealth: u64,
        wealth_source: field,
        net_worth: u64,
    }

    struct InvestmentExperience {
        ref_id: field,
        has_stocks: bool,
        has_bonds: bool,
        has_mutual_funds: bool,
        has_etf: bool,
        has_real_estate: bool,
        has_commodities: bool,
        has_crypto: bool,
        has_options_futures: bool,
        has_forex: bool,
        has_venture_capital: bool,
        has_hedge_funds: bool,
        has_cd: bool,
        has_money_market: bool,
        has_annuities: bool,
        risk_tolerance: u8,
        goal_1: field,
        goal_2: field,
        goal_3: field,
        goal_4: field,
        goal_5: field,
    }

    struct PEPStatus {
        ref_id: field,
        is_politically_exposed: bool,
        assoc_declaration_1: field,
        assoc_declaration_2: field,
        assoc_declaration_3: field,
        assoc_declaration_4: field,
        assoc_declaration_5: field,
    }

    struct RiskAssessment {
        ref_id: field,
        country_risk_level: u8,
        country_reason_1: field,
        country_reason_2: field,
        emp_risk_level: u8,
        emp_reason_1: field,
        emp_reason_2: field,
        act_risk_level: u8,
        act_amount: u64,
        act_frequency: field,
        act_reason_1: field,
        act_reason_2: field,
    }

    // Create two copies of the KYC, one for the customer and one for the institution.
    record KYCData {
        private owner: address,
        private secondary_owner: address,
        private risk_assessment: RiskAssessment,
        private pep_status: PEPStatus,
        private investment_experience: InvestmentExperience,
        private financial_profile: FinancialProfile,
        private professional_info: ProfessionalInfo,
        private contact_details: ContactDetails,
        private individual_info: IndividualInfo,
        private created_at: field,
    }

    record FinancialInstitutionData {
        private owner: address,
        private is_trusted: bool,
        id: field,
        private company_name_1: field,
        private company_name_2: field,
        private company_type: field,
        private company_address_1: field,
        private company_address_2: field,
        private company_address_3: field,
        private company_state: field,
        private company_country: field,
        private email: field,
        private email_domain: field,
        private alt_email: field,
        private alt_email_domain: field,
        private phone_code: u32,
        private area_code: u32,
        private phone: u32,
        created_at: field,
    }

    // Map financial institutions' IDs to addresses.
    mapping financial_institutions: field => address;

    // Map financial institution addresses to boolean values indicating DAO approval.
    mapping trusted_financial_institutions: address => bool;

    transition create_institution(fi_data: FinancialInstitutionData) -> FinancialInstitutionData {
        let new_fi_data: FinancialInstitutionData = FinancialInstitutionData {
            owner: self.caller,
            is_trusted: false,
            id: fi_data.id,
            company_name_1: fi_data.company_name_1,
            company_name_2: fi_data.company_name_2,
            company_type: fi_data.company_type,
            company_address_1: fi_data.company_address_1,
            company_address_2: fi_data.company_address_2,
            company_address_3: fi_data.company_address_3,
            company_state: fi_data.company_state,
            company_country: fi_data.company_country,
            email: fi_data.email,
            email_domain: fi_data.email_domain,
            alt_email: fi_data.alt_email,
            alt_email_domain: fi_data.alt_email_domain,
            phone_code: fi_data.phone_code,
            area_code: fi_data.area_code,
            phone: fi_data.phone,
            created_at: fi_data.created_at,
        };

        return new_fi_data then finalize(self.caller, fi_data.id);
    }

    finalize create_institution(owner: address, fi_id: field) {
        assert(Mapping::get(financial_institutions, fi_id) != owner);

        Mapping::set(financial_institutions, fi_id, owner);
    }

    transition approve_institution(fi_data: FinancialInstitutionData) -> FinancialInstitutionData {
        // Check that the caller belongs to the DAO.
        let new_fi_data: FinancialInstitutionData = FinancialInstitutionData {
            owner: fi_data.owner,
            is_trusted: true,
            id: fi_data.id,
            company_name_1: fi_data.company_name_1,
            company_name_2: fi_data.company_name_2,
            company_type: fi_data.company_type,
            company_address_1: fi_data.company_address_1,
            company_address_2: fi_data.company_address_2,
            company_address_3: fi_data.company_address_3,
            company_state: fi_data.company_state,
            company_country: fi_data.company_country,
            email: fi_data.email,
            email_domain: fi_data.email_domain,
            alt_email: fi_data.alt_email,
            alt_email_domain: fi_data.alt_email_domain,
            phone_code: fi_data.phone_code,
            area_code: fi_data.area_code,
            phone: fi_data.phone,
            created_at: fi_data.created_at,
        };

        return new_fi_data then finalize(self.call
