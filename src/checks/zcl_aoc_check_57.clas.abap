CLASS zcl_aoc_check_57 DEFINITION
  PUBLIC
  INHERITING FROM zcl_aoc_super
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor.

    METHODS check
        REDEFINITION.
    METHODS get_attributes
        REDEFINITION.
    METHODS get_message_text
        REDEFINITION.
    METHODS if_ci_test~query_attributes
        REDEFINITION.
    METHODS put_attributes
        REDEFINITION.
  PROTECTED SECTION.

    DATA mv_into TYPE sap_bool.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOC_CHECK_57 IMPLEMENTATION.


  METHOD check.

* abapOpenChecks
* https://github.com/larshp/abapOpenChecks
* MIT License

    DATA: lt_statements TYPE ty_statements.

    FIELD-SYMBOLS: <ls_statement> LIKE LINE OF lt_statements.


    IF object_type <> 'CLAS'.
      RETURN.
    ENDIF.

    lt_statements = build_statements(
        it_tokens     = it_tokens
        it_statements = it_statements
        it_levels     = it_levels ).

    LOOP AT lt_statements ASSIGNING <ls_statement>.
      IF <ls_statement>-str NP 'MESSAGE *'
          OR ( mv_into = abap_true AND <ls_statement>-str CP '* INTO *' ).
        CONTINUE.
      ENDIF.

      inform( p_sub_obj_type = c_type_include
              p_sub_obj_name = <ls_statement>-include
              p_line         = <ls_statement>-start-row
              p_kind         = mv_errty
              p_test         = myname
              p_code         = '001' ).
    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    super->constructor( ).

    description = 'MESSAGE in global classes'.              "#EC NOTEXT
    category    = 'ZCL_AOC_CATEGORY'.
    version     = '001'.
    position    = '057'.

    has_attributes = abap_true.
    attributes_ok  = abap_true.

    mv_errty = c_error.
    mv_into = abap_true.

  ENDMETHOD.                    "CONSTRUCTOR


  METHOD get_attributes.

    EXPORT
      mv_errty = mv_errty
      mv_into = mv_into
      TO DATA BUFFER p_attributes.

  ENDMETHOD.


  METHOD get_message_text.

    CLEAR p_text.

    CASE p_code.
      WHEN '001'.
        p_text = 'MESSAGE in global classes'.               "#EC NOTEXT
      WHEN OTHERS.
        super->get_message_text( EXPORTING p_test = p_test
                                           p_code = p_code
                                 IMPORTING p_text = p_text ).
    ENDCASE.

  ENDMETHOD.


  METHOD if_ci_test~query_attributes.

    zzaoc_top.

    zzaoc_fill_att mv_errty 'Error Type' ''.                "#EC NOTEXT
    zzaoc_fill_att mv_into 'Allow INTO' 'C'.                "#EC NOTEXT

    zzaoc_popup.

  ENDMETHOD.


  METHOD put_attributes.

    IMPORT
      mv_errty = mv_errty
      mv_into = mv_into
      FROM DATA BUFFER p_attributes.                 "#EC CI_USE_WANTED
    ASSERT sy-subrc = 0.

  ENDMETHOD.
ENDCLASS.