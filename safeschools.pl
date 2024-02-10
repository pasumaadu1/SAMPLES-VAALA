# my $private_key_jwt;
# $private_key_jwt needs to be created in safeschools_local.pl
# $private_key_jwt must contain an RS256 private key
# to generate the key run the command below in the terminal

# CREATE PRIVATE KEY RS256
# ssh-keygen -t rsa -b 4096 -m PEM -f jwtRS256.key

# ex: $private_key_jwt
# my $private_key_jwt = <<'EOF';
# -----BEGIN RSA PRIVATE KEY-----
# key
# -----END RSA PRIVATE KEY-----
# EOF

# my $public_key_jwt;
# $public_key_jwtneeds to be created in safeschools_local.pl
# $public_key_jwt must contain an private key RS256
# to generate the key run the command below in the terminal

# CREATE PUBLIC KEY RS256
# openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub

# ex: $private_key_jwt
# my $public_key_jwt = <<'EOF';
# -----BEGIN RSA PUBLIC KEY-----
# key
# -----END RSA PUBLIC KEY-----
# EOF

{
  schemas => {
    SafeSchoolsDB => {
      class => 'SafeSchools::Schema::SafeSchoolsDB',
      time_zone => 'America/New_York',
      rw => [
        $ENV{SS2DSN} || 'DBI:mysql:database=safeschools2_dev_1:host=localhost',
        '',
        '',
            ],
      ro             => 'rw',
      training_logic => 'ro',
      pal            => 'ro',
      course_list    => 'ro',
      table_report   => 'ro',
      i18n           => 'ro',
      search         => 'ro',
      oauth_token    => 'ro',
                     },
    AcceptanceDB => {
      class => 'SafeSchools::Schema::AcceptanceDB',
      rw => [
        $ENV{SS2DSN} || 'DBI:mysql:database=safeschools2_dev_1:host=localhost',
        '',
        '',
      ],
      ro => [
        $ENV{SS2DSN} || 'DBI:mysql:database=safeschools2_dev_1:host=localhost',
        '',
        '',
      ],
    },
  },
  'Model::SafeSchoolsDB' => {
    schema_class => 'SafeSchools::Schema::SafeSchoolsDB',
    connect_info => 'rw',
  },
  'Model::Sessions' => {
    connect_info => [
      'DBI:mysql:database=sessions:host=localhost',
      '',
      '',
                    ],
  },

  PostAssessmentSurvey => {
    profiles => {
      disable => {},
      standard => {
        required => [
                      'overall_rating',
                    ],
        optional => [
                      'comments',
                    ],
        hidden   => [
                      'course_met_expectations',
                      'course_was_logical',
                      'course_time_appropriate',
                      'objectives_appropriate',
                      'promoted_professional_dev',
                    ],
      },
      all => {
        required => [
                      'overall_rating',
                      'comments',
                      'course_met_expectations',
                      'course_was_logical',
                      'course_time_appropriate',
                      'objectives_appropriate',
                      'promoted_professional_dev',
                    ],
      }
    },
    questions => {
      overall_rating => {
        text => 'What is your overall rating for this course?',
        type => 'satisfaction'
      },
      comments => {
        text => 'Do you have any additional comments?',
        type => 'text'
      },
      course_met_expectations => {
        text => 'This content met your expectations.',
        type => 'agreement'
      },
      course_was_logical => {
        text => 'The content was arranged in a clear and logical way.',
        type => 'agreement'
      },
      course_time_appropriate => {
        text => 'The time allotted to the content was appropriate.',
        type => 'agreement'
      },
      objectives_appropriate => {
        text => 'The exam questions appropriately measured the learning objectives.',
        type => 'agreement'
      },
      promoted_professional_dev => {
        text => 'This content will contribute to your professional growth.',
        type => 'agreement'
      },
    },
    scales => {
      satisfaction => [
                        'Poor',
                        'Below Average',
                        'Average',
                        'Above Average',
                        'Great',
                      ],
      agreement    => [
                        'Strongly Disagree',
                        'Disagree',
                        'Neutral',
                        'Agree',
                        'Strongly Agree',
                      ]
    }
  },

  pal_perf => 0,

  'Scheme::EmailQueue' => {
    defaults => {
                  from_address => 'noreply@safeschools.com',
                  priority     => undef,
                },
    emails => {
      train_plan => {
                      text_template => 'train_plan_text.tt2',
                      html_template => 'train_plan_html.tt2',
                      attach_list   => 'images/bg/stripe_subtle_gray.png',
                      subject       => 'Your SafeSchools Training plan',
                      priority      => undef,
                    },
      admin_compl => {
                       html_template => 'admin_compl_html.tt2',
                       text_template => 'admin_compl_text.tt2',
                       attach_list   => 'images/bg/stripe_subtle_gray.png',
                       subject       => 'Your SafeSchools Compliance Report',
                       priority      => undef,
                     },
              },
  },

  'Choices::EmailReminderDays' => {
    7 => {
           days => 7,
           text => "1 week",
         },
    14 => {
            days => 14,
            text => "2 weeks",
          },
    30 => {
            days => 30,
            text => "1 month",
          },
    60 => {
            days => 60,
            text => "2 months",
          },
  },

  versioned_static => {
              sl_player   => 'https://a.trainingcdn.com/sl_player/v0.20.3/',
              sl_jwplayer => 'https://a.trainingcdn.com/sl_jwplayer/v1.05.4/',
              slip        => 'https://a.trainingcdn.com/sl_jwplayer/v1.44/',
              jca_scorm   => 'https://a.trainingcdn.com/jca_scorm/v1.0/',
                      },

  lwp_simple_timeout => 5,

  static_uri => {
    prefix            => 'https://a.trainingcdn.com/static/',
    static_versioning => 1,
    version_override  => {},
    prefix_timeout    => 30,

    # These are relative to root/static/
    version_prefixes => {
                          'ember'    => 1,
                          'js'       => 1,
                          'tinymce'  => 1,
                          'ng'       => 1,
                          'react'    => 1,
                          'uui'      => 1,
                          'surveyjs' => 1,
                          'styles'   => 1,
                          'v3'       => 1,
                          'v4'       => 1,
                        },
                },

  cdn_uri_convert => {
    from => 'https://s3.amazonaws.com/',
    to   => 'https://a.trainingcdn.com/',
    AltMediaManifest => {
      from =>
        'https://vector-altmedia-content-prod-aiad-main-sss10.s3.us-east-1.amazonaws.com/',
    },
    AltMediaMp3 => {
      from =>
        'https://s3.us-east-1.amazonaws.com/vector-altmedia-content-prod-aiad-main-sss10/',
    },
  },

  ucc_url          => undef,
  streaming_prefix => 'http://static.safeschools.com/course-video/',
  swf_prefix       => 'http://static.safeschools.com',
  gateway_url      => "http://10.200.200.118:55534",
  sl_publisher_id  => 'e814bc06-6ba2-11e6-af28-2292f08edab4',

  # Any truthy value works, but a description is nice
  dupinator_publishers => {
    'f5065984-7142-11e6-b4f2-2292f08edab4' => 'SBSC',
    '20CB9350-CB5F-11EA-A39E-F90B6A471DCB' => 'DiversityEdu',
  },

  teachpoint => {
    coursework_url => 'https://tp4.goteachpoint.com/api/safeschools/courseresults',
    max_records    => 500,
  },
  pcg => {
    coursework_url   => 'https://www0.pepperpd.com/safeschools/receive',
  },
  journey => {
    ignore_journey_status      => 0,
    quick_timeout => 4,
    jwt_configs => {
      previous => {
                    active       => 0,
                    key          => '...',
                    accepted_alg => 'PBES2-HS512+A256KW',
                    alg          => 'PBES2-HS512+A256KW',
                    enc          => 'A256GCM',
                  },
      current => {
                   active       => 0,
                   key          => 'NotASecret',
                   accepted_alg => 'PBES2-HS512+A256KW',
                   alg          => 'PBES2-HS512+A256KW',
                   enc          => 'A256GCM',
                   relative_exp => 30,
                   verify_exp   => 1,
                 },
    },
    culture_codes => {
                       US  => 'en',         # United States
                       CA  => 'fr-CA',      # Canada
                       MX  => 'es-MX',      # Mexico
                       PR  => 'es',         # Puerto Rico
                       VI  => 'en',         # Virgin Islands

                       EN  => 'en',         # English
                       ES  => 'es',         # Spanish
                       FR  => 'fr',         # French
                       AF  => 'af',         # Afrikaans

                       'AR-SA' => 'ar',     # Arabic
                       'BG-BG' => 'bg',     # Bulgarian
                       'CS-CZ' => 'cs',     # Czech
                       'DA-DK' => 'da',     # Danish
                       'DE-DE' => 'de',     # German
                       'EL-GR' => 'el',     # Greek
                       'EN-US' => 'en',     # English
                       'ES-ES' => 'es',     # Spanish (Europe)
                       'ES-MX' => 'es-MX',  # Spanish (Mexican)
                       'ET-EE' => 'et',     # Estonian
                       'FI-FI' => 'fi',     # Finnish
                       'FR-CA' => 'fr-CA',  # French (Canada)
                       'FR-FR' => 'fr',     # French
                       'HE-IL' => 'he',     # Hebrew (Israel)
                       'HI-IN' => 'hi',     # Hindi
                       'HR-HR' => 'hr',     # Croatian
                       'HU-HU' => 'hu',     # Hungarian
                       'ID-ID' => 'id',     # Indonesian
                       'IT-IT' => 'it',     # Italian
                       'JA-JP' => 'ja',     # Japanese
                       'KO-KR' => 'ko',     # Korean
                       'LT-LT' => 'lt',     # Lithuanian
                       'LV-LV' => 'lv',     # Latvian
                       'MS-MY' => 'ms',     # Malay
                       'MT-MT' => 'mt',     # Maltese
                       'NL-NL' => 'nl',     # Dutch
                       'PL-PL' => 'pl',     # Polish
                       'PT-BR' => 'pt-BR',  # Portuguese (Brazilian)
                       'PT-PT' => 'pt',     # Portuguese (European)
                       'RO-RO' => 'ro',     # Romanian
                       'RU-RU' => 'ru',     # Russian
                       'SK-SK' => 'sk',     # Slovak
                       'SL-SI' => 'sl',     # Slovenian
                       'SV-SE' => 'sv',     # Swedish
                       'TH-TH' => 'th',     # Thai
                       'TL-PH' => 'tl',     # Filipino Tagalog
                       'TR-TR' => 'tr',     # Turkish
                       'UK-UA' => 'uk',     # Ukrainian
                       'VI-VN' => 'vi',     # Vietnamese
                       'ZH-CN' => 'zh',     # Chinese (Simplified-Mandarin)*
                       'ZH-TW' => 'zh-TW',  # Chinese (Traditional-Mandarin)*
                     },
  },

  memcached_servers => [ 'localhost:11211', ],
  cache_timeout => {
    ci_augment_slugs               => '8 hours',
    course_icon_path               => '30 mins',
    course_item_m3u8               => '60 secs',
    course_published               => '4 hours',
    courses_in_extra_training      => '5 mins',
    dist_course_list               => '30 mins',
    dist_extra_training            => '1 day',
    dist_get_pref                  => '60 secs',
    dist_pii                       => '1 day',
    embeddable_dashboard           => '10 mins',
    external_api_author            => 1,           # Real value in config{api}
    external_api_course            => 1,           # Real value in config{api}
    external_video_info            => '60 secs',
    generated_hls_playlist_timeout => '60 secs',
    get_extra_template_paths       => '5 mins',
    i18n_lexicon_clear             => '5 mins',
    i18n_player_data               => '60 secs',
    instructors                    => '30 mins',
    jam_debug_storage              => '12 hours',
    json_player_data               => '60 mins',
    lang_translation               => '1 day',
    missing_caption_refresh        => '6 hours',
    pos_bldg_job_count             => '30 mins',
    recent_auto_upload             => '1 hour',
    recent_cim_rollup              => '4 hours',
    recent_dist_email              => '2 hours',
    slip_i18n_list                 => '1 day',
    translate_survey               => '60 secs',
    vidp_jwt_key                   => '1 hour',
    vidp_org_lookup                => '1 day',
                   },

  transient_request_data_minutes => 5,

  system_pref => {
                   config_timeout => 30,
                 },

  config_override => {
    market => {
      'MARKET-GUID-SAFESTUDENTS-SS' => {
        uses_passwords => 1,
      },
    },
  },

  s3_upload => {
    caption_publish => {
      access_key    => '',
      secret_key    => '',
      upload_bucket => '',
      upload_prefix => '',
      output_prefix => '',
    },
    translations_pipeline => {
      access_key    => '',
      secret_key    => '',
      upload_bucket => '',
      upload_prefix => '',
      output_prefix => '',
    },
    augment_resources => {
      access_key    => '',
      secret_key    => '',
      upload_bucket => 'sl-ccc-icons',
      upload_prefix => 'augmentation_resources',
      max_filesize  => 16 * 1024 * 1024,
    },
    dist_logos => {
      access_key    => '',
      secret_key    => '',
      upload_bucket => 'safeschools-static',
      upload_prefix => 'static/images/',
    },
    alt_media_manifest => {
      access_key    => '',
      secret_key    => '',
      upload_bucket => 'vector-altmedia-content-prod-aiad-main-sss10',
      upload_prefix => 'alt_media_manifests/',
    },
  },
  course_icons =>
  {
    max_filesize => 16 * 1024 * 1024,
    aws =>
    {
      source_prefix => 'https://a.trainingcdn.com/',
      source_bucket => 'sl-ccc-icons-resized',
      upload_bucket => 'sl-ccc-icons',
    },
  },
  scorm_packages =>
  {
    aws => {
      access_key    => '',
      secret_key    => '',
      upload_bucket => 'scorm-3p',
    },
  },

  translate_service =>
  {
    aws => {
      access_key    => '',
      secret_key    => '',
      target        => 'AWSShineFrontendService_20170701.TranslateText',
    },
  },

  narrate_service =>
  {
    enable => 0,
    aws => {
      access_key         => '',
      secret_key         => '',
      output_bucket      => 'vector-altmedia-content-prod-aiad-main-sss10',
      output_prefix      => 'alt_media_mp3s/',
      service_name       => 'polly',
      region             => 'us-east-1',
      start_task_target  => 'StartSpeechSynthesisTask',
      start_task_timeout => 3,
      check_task_target  => 'GetSpeechSynthesisTask',
      check_task_timeout => 3,
      temporary_errors   => [
        'Rate exceeded',
        'Transport endpoint is not connected',
        # Access, credential, key, signature, certificate errors, timeouts
        # with configs are  included for convenience during testing. These
        # will need intervention to fix in production, so they are not always
        # temporary.
        #'read timeout',
        #'security token included in the request is invalid',
        #'Access Key Id you provided does not exist in our records',
        #'Access denied',
        #'The request signature we calculated does not match the signature you provided',
        #'certificate verify failed',
      ],
      #NOTE: request_defaults and lang_defaults may be subject to selective
      # serialization as filenames to provide context to narration files that
      # are produced. If we add or change any values, consider whether we want
      # to use those values as part of the output filenames.
      request_defaults  => {
        'Engine'             => 'standard',
        'TextType'           => 'text',
        'OutputFormat'       => 'mp3',
        'SampleRate'         => '22050',
        # Populated by output_bucket, output_prefix.
        # Those may be overridden here.
        #'OutputS3BucketName' => '',
        #'OutputS3KeyPrefix'  => '',
      },
      #TODO: this could be auto-updated by periodic calls
      # to DescribeVoices; maybe when the alt media
      # background script starts up?
      # (for now we'll just pick voices)
      lang_defaults => {
        ar      => {
          VoiceId => 'Zeina',
          LanguageCode => 'arb',
        },
        da      => {
          VoiceId   => 'Mads',
          LanguageCode => 'da-DK',
        },
        de      => {
          VoiceId   => 'Hans',
          LanguageCode => 'de-DE',
        },
        en      => {
          VoiceId   => 'Joanna',
          LanguageCode => 'en-US',
        },
        es      => {
          VoiceId   => 'Enrique',
          LanguageCode => 'es-ES',
        },
        'es-MX' => {
          VoiceId   => 'Mia',
          LanguageCode => 'es-MX',
        },
        'es-US' => {
          VoiceId   => 'Miguel',
          LanguageCode => 'es-US',
        },
        fr      => {
          VoiceId   => 'Mathieu',
          LanguageCode => 'fr-FR',
        },
        'fr-CA' => {
          VoiceId   => 'Chantal',
          LanguageCode => 'fr-CA',
        },
        hi      => {
          VoiceId   => 'Aditi',
          LanguageCode => 'hi-IN',
        },
        it      => {
          VoiceId   => 'Carla',
          LanguageCode => 'it-IT',
        },
        ja      => {
          VoiceId   => 'Mizuki',
          LanguageCode => 'ja-JP',
        },
        ko      => {
          VoiceId   => 'Seoyeon',
          LanguageCode => 'ko-KR',
        },
        nl      => {
          VoiceId   => 'Lotte',
          LanguageCode => 'nl-NL',
        },
        pl      => {
          VoiceId   => 'Jacek',
          LanguageCode => 'pl-PL',
        },
        pt      => {
          VoiceId   => 'Cristiano',
          LanguageCode => 'pt-PT',
        },
        'pt-BR' => {
          VoiceId   => 'Ricardo',
          LanguageCode => 'pt-BR',
        },
        ro      => {
          VoiceId   => 'Carmen',
          LanguageCode => 'ro-RO',
        },
        ru      => {
          VoiceId   => 'Maxim',
          LanguageCode => 'ru-RU',
        },
        sv      => {
          VoiceId   => 'Astrid',
          LanguageCode => 'sv-SE',
        },
        tr      => {
          VoiceId   => 'Filiz',
          LanguageCode => 'tr-TR',
        },
        zh      => {
          VoiceId   => 'Zhiyu',
          LanguageCode => 'cmn-CN',
        },
        'zh-TW' => {
          VoiceId   => 'Zhiyu',
          LanguageCode => 'cmn-CN',
        },
      },
    },
  },

  external_media => {
    translations_pipeline => {
      source_uri_to_s3_regex => '^.*trainingcdn[^/]+[/]',
      asset_host             => 'https://api.safeschools.com',
      source_language        => 'en',
      languages              => [qw/es fr/],
    },
    jwt_configs => {
      current => {
                   active       => 1,
                   key          => 'NotASecret',
                   accepted_alg => 'PBES2-HS512+A256KW',
                   alg          => 'PBES2-HS512+A256KW',
                   enc          => 'A256GCM',
                 },
    },
  },

  external_video_service =>
  {
    vimeo =>
    {
      api_url => 'https://vimeo.com/api/oembed.json',
    },
    youtube =>
    {
      api_url => 'https://www.googleapis.com/youtube/v3/videos',
      api_key => '',                                            ### REQUIRED
    },
  },

  training =>
  {
    progress_save =>
    {
      minimum_update => 5,
      max_early_updates => 1,
    },
    debug_augmentations =>
    {
      'DIST-GUID-TEST' => 1,
    },
    verify_pal_count => 0,
  },

  uploader =>
  {
    recheck_hours => 6,
    sftp => {
      script_path => 'bin/sftp_download.sh',
      username => '',
      hostname => '',
    },
  },

  saml =>
  {
    # URLs to direct SAML traffic to.
    gateway =>
    {
      base_url    => $ENV{SL_SAML_GATEWAY_URL}
                     || 'https://saml-live.scenariolearning.com',
      login_url   => '/saml/redirect',
      logout_url  => '/saml/logout',
    },
  },

  vhost => {
    dots_required => {
                       'courses.vectorsolutions.com' => 1,
                     },
    removals => {
                  staging => 1,
                  testing => 1,
                  build   => 1,
                  focus   => 1,
                },
    domains => {
                 safeschools      => 1,
                 safecolleges     => 1,
                 safepersonnel    => 1,
                 safecampus       => 1,
                 exceptionalchild => 1,
                 safefaith        => 1,
                 safestudents     => 1,
                 vectorlmsedu     => 1,
               },
           },

  salami => {
    default_author_pic_url => '/static/images/authors/default.png',
  },

  ember => {
    build => 0,
  },

  react => {

            # The survey-library directory, not the build directory
            surveyjs_path => '~/git-working/survey-library',
            build         => 1,
           },

  locale =>
  {
    'en-US' =>
    {
      dates =>
      {
        jquery_datepicker   => 'mm/dd/yy',
        angular_date_filter => 'M/dd/yyyy',
        tt2_date_format     => '%m/%d/%Y',
      },
    },
    'en-ZA' =>
    {
      dates =>
      {
        jquery_datepicker   => 'dd/mm/yy',
        angular_date_filter => 'dd/M/yyyy',
        tt2_date_format     => '%d/%m/%Y',
      },
    },
    'DEFAULT' => 'en-US',
  },

  # Deal with 500s.
  # safeschools_local on staging/production needs (or dev to test emails):
  # 'Plugin::ErrorCatcher' => { enable => 1 },
  #
  # And to set email addresses:
  # 'Plugin::ErrorCatcher::Email' =>
  # {
  #   to =>
  #   [
  #     'address1',
  #     'address2',
  #     ...
  #   ]
  # }
  'Plugin::ErrorCatcher' =>
  {
    enable => 1,
    emit_module =>
    [
      'SafeSchools::ErrorCatcher'
    ],
  },

  error_dump => {
                  enable       => 1,
                  session_dump => 1,
                },

  'Plugin::ErrorCatcher::Email' =>
  {
    from => 'support@scenariolearning.com',
    use_tags => 1,
    subject => '500 Error on %h in %p line %l.',
  },

  stacktrace => { enable => 1 },

  watchdog => {
                user     => 'read_only',
                pass     => '',
                max_time => 120,
                hook_url => undef,
                do_kill  => 0,
              },

  terms =>
  {
    default =>
    {
      employee =>
      {
        singular => 'employee',
        plural   => 'employees',
        article  => 'an',
      },
      position =>
      {
        singular => 'position',
        plural   => 'positions',
        article  => 'a',
      },
      new_hire =>
      {
        singular => 'new hire',
        plural   => 'new hires',
        article  => 'a',
      },
      job =>
      {
        singular => 'job',
        plural   => 'jobs',
        article  => 'a',
      },
      quiz =>
      {
        singular => 'assessment',
        plural   => 'assessments',
        article  => 'an',
      },
    },
    learner =>
    {
      employee =>
      {
        singular => 'learner',
        plural   => 'learners',
        article  => 'a',
      },
      position =>
      {
        singular => 'classification',
        plural   => 'classifications',
        article  => 'a',
      },
      new_hire =>
      {
        singular => 'new learner',
        plural   => 'new learners',
        article  => 'a',
      },
      job =>
      {
        singular => 'role',
        plural   => 'roles',
        article  => 'a',
      },
    },
  },

  html_scrubber =>
  {
    profiles => {
      quiz_question => {
                         allow => {
                                    div        => 1,
                                    span       => 1,
                                    i          => 1,
                                    u          => 1,
                                    b          => 1,
                                    ul         => 1,
                                    ol         => 1,
                                    li         => 1,
                                    h1         => 1,
                                    h2         => 1,
                                    h3         => 1,
                                    h4         => 1,
                                    h5         => 1,
                                    p          => 1,
                                    strong     => 1,
                                    em         => 1,
                                    hr         => 1,
                                    pre        => 1,
                                    code       => 1,
                                    br         => 1,
                                    kbd        => 1,
                                    blockquote => 1,
                                    cite       => 1,
                                    del        => 1,
                                    s          => 1,
                                    sup        => 1,
                                    sub        => 1,
                                    strike     => 1,
                                    section    => 1,
                                    'vs-x'     => 1,
                                  },
                         rules => {
                                    h2 => { 'class' => 1 },
                                    default => [ 0 => { '*' => 0 } ],
                                  },
                       },
      course_item => {
        allow => {
                   div        => 1,
                   span       => 1,
                   a          => 1,
                   img        => 1,
                   i          => 1,
                   u          => 1,
                   ins        => 1,
                   b          => 1,
                   table      => 1,
                   tr         => 1,
                   th         => 1,
                   tbody      => 1,
                   thead      => 1,
                   ul         => 1,
                   ol         => 1,
                   li         => 1,
                   h1         => 1,
                   h2         => 1,
                   h3         => 1,
                   h4         => 1,
                   h5         => 1,
                   p          => 1,
                   strong     => 1,
                   em         => 1,
                   hr         => 1,
                   pre        => 1,
                   code       => 1,
                   br         => 1,
                   kbd        => 1,
                   blockquote => 1,
                   cite       => 1,
                   del        => 1,
                   s          => 1,
                   sup        => 1,
                   sub        => 1,
                   strike     => 1,
                   section    => 1,
                   'vs-x'       => 1,
                 },
        style => 1,
        rules => {
          a => {
                 href => '^(?:http|https|ftp)://',
                 target => 1,
               },
          tr => {
                  colspan => 1,
                  rowspan => 1,
                },
          td => {
                  colspan => 1,
                  rowspan => 1,
                },
          img => {
                   src   => '^(?:http|https|ftp)://',
                   alt   => 1,
                   title => 1,
                 },
          default => [ 0 => { '*' => 0 } ],
                 },
      },
      page_html_override => {
        allow => {
                   div        => 1,
                   span       => 1,
                   a          => 1,
                   img        => 1,
                   i          => 1,
                   u          => 1,
                   b          => 1,
                   table      => 1,
                   tr         => 1,
                   th         => 1,
                   tbody      => 1,
                   thead      => 1,
                   ul         => 1,
                   ol         => 1,
                   li         => 1,
                   h1         => 1,
                   h2         => 1,
                   h3         => 1,
                   h4         => 1,
                   h5         => 1,
                   p          => 1,
                   strong     => 1,
                   em         => 1,
                   hr         => 1,
                   pre        => 1,
                   code       => 1,
                   br         => 1,
                   kbd        => 1,
                   blockquote => 1,
                   cite       => 1,
                   del        => 1,
                   s          => 1,
                   sup        => 1,
                   sub        => 1,
                   strike     => 1,
                   section    => 1,
                   'vs-x'     => 1,
        },
        style => 1,
        rules => {
          a => {
                 href => '^(?:http|https)://',
               },
          tr => {
                  colspan => 1,
                  rowspan => 1,
                },
          td => {
                  colspan => 1,
                  rowspan => 1,
                },
          img => {
                   src   => '^(?:http|https)://',
                   alt   => 1,
                   title => 1,
                 },
          default => [ 0 => { '*' => 0 } ],
        },
      },
    },
  },

  api =>
  {
    cache =>
    {
      seconds => 3600,
      enabled => 1,
    },
  },

  graphql => {
               max_depth_allowed        => 10,
               sandbox                  => 0,
               access_token_timeout_min => 30,
               # How much to divide the cost score by to keep numbers
               # reasonable.
               complexity_score_divisor => 10,
             },

  email => {
    incoming => {
      message_limit => 10,
      watch_folders => [qw[admin administrator]],
      src_prefix    => 'safeschools.com/incoming',
      copy_prefix   => 'safeschools.com/processed',
      except_prefix => 'safeschools.com/exceptions',

      imap_connection => {
                           Server   => 'imap.gmail.com',
                           User     => 'incoming-imap@safeschools.com',
                           Port     => '993',
                           Password => '...',
                           Ssl      => 1,
                           Uid      => 1,
                         },
                },
    sender => {

      globals => {},

      # Only one of these is used at a time.
      profiles => {
        default => {
                     host => 'mailhost',
                   },
        localhost => {
                       host => 'localhost',
                     },
        # Use a specific profile for a destination domain
        '@gmail.com' => {
                   Host     => 'email-smtp.us-east-1.amazonaws.com:465',
                   ssl      => 1,
                   username => '',
                   password => '',
                        },
                  },
              },

    o365_oauth => {
                   redirect_uri     => 'https://127.0.0.1',
                   client_id        => '8eba0eb6-1bc5-4431-b3c9-4fbb262c0a82',
                   tenant_id        => 'fd01ebd7-e586-4325-92d2-7ad43688e011',
                   client_secret_id => '',
                   client_secret    => '',
                   token_key        => '',
                  },
           },

  keenan_sso =>
  {
    base_urls =>
    {
      QA      => 'https://pcb-qa.keenan-pcbridge.com/weblogicsso/api/xml',
      Stage   => 'https://pcb-pp.keenan-pcbridge.com/weblogicsso/api/xml',
      Preprod => 'https://beta.keenan-pcbridge.com/weblogicsso/api/xml',
      Prod    => 'https://www.keenan-pcbridge.com/weblogicsso/api/xml',
      Dev     => 'https://dev-pcb.keenan-pcbridge.com/weblogicsso/api/xml',
    },
  },

  pal_refresh => {
    priority => {
      completion => {
        highest => 5,
        default => 10,
      },
    },
  },

  dist_duplicator => {
    shared_secret => 'U4a9Rn@tzatfMWrT7mnVnaV&32*edC@K',
  },

  # quicksight_reports jwk needs to be created in safeschools_local.pl.
  # Example:
  # quicksight_reports =>
  # {
  #   environment => "sst-dev-us",
  #   jwk =>
  #   {
  #     '2022-07-01' =>
  #     {
  #       private_key => $private_key_jwt,
  #       public_key  => $public_key_jwt,
  #       alg         => 'RS256',
  #     },
  #   },
  # },
  quicksight_reports => {
    environment => 'sst-dev-us',
    env_origin  => 'https://test.sprint.safeschools.com/',
    jwk         => {},
    active_jwk  => '2022-07-01',
    url         =>
    'https://qa.data.vectorsolutions.com/qs-embedded-urls/v1/safeschools/validator/',

    endpoints => {
      create  => 'user-status',
      get_url => 'urls',
    },
    reports => {
      survey_results => {
        name         => 'Survey Results',
        dashboard_id => '80f89947-de33-4d7d-b0c6-0a6733293d31',
        sort_order   => 1,
      },
      survey_results_benchmarking => {
        name         => 'Survey Results',
        dashboard_id => 'e38946d5-d9e5-4ffa-984c-50f51b2cd20e',
        sort_order   => 2,
      },
      drinker_profile => {
        name         => 'Drinker Profile',
        dashboard_id => 'e3a7aa1b-ead1-4881-837f-d1ca0b9cdef8',
        sort_order   => 3,
      },
      student_engage => {
        name         => 'Student Engagement',
        dashboard_id => '91ba9f6c-8bfa-4faf-ac30-2384f2df8496',
        sort_order   => 4,
      },
    },
  },
  allowed_mime_types => {
    policy => [
      qw{
        application/pdf
        application/x-pdf
        application/vnd.ms-excel
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        application/msword
        application/vnd.openxmlformats-officedocument.wordprocessingml.document
        application/vnd.ms-powerpoint
        application/vnd.openxmlformats-officedocument.presentationml.presentation
        application/vnd.oasis.opendocument.presentation
        application/vnd.oasis.opendocument.spreadsheet
        application/vnd.oasis.opendocument.text
      },
    ],
    augments => [
      qw{
        application/pdf
        application/x-pdf
        application/vnd.ms-excel
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        application/msword
        application/vnd.openxmlformats-officedocument.wordprocessingml.document
        application/vnd.ms-powerpoint
        application/vnd.openxmlformats-officedocument.presentationml.presentation
        application/vnd.oasis.opendocument.presentation
        application/vnd.oasis.opendocument.spreadsheet
        application/vnd.oasis.opendocument.text
        application/postscript
        image/avif
        image/bmp
        image/gif
        image/vnd.microsoft.icon
        image/jpeg
        image/png
        image/svg+xml
        image/tiff
        image/webp
        text/plain
      }
      #text/plain is necessary for testing
    ],
  },
  #'SafeSchools::LogDisable' => ('debug'),
}
