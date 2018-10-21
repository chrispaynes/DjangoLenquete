from django.contrib import admin
from .models import Choice, Question


class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 3  # default to provide 3 field choices


class QuestionAdmin(admin.ModelAdmin):
    # sets the tabular column order for http://localhost:8000/admin/polls/question/
    list_display = ('question_text', 'pub_date', 'was_published_recently')

    # allows for filtering questions by published date for http://localhost:8000/admin/polls/question/
    list_filter = ['pub_date']

    # allows for searching for questions by their title for http://localhost:8000/admin/polls/question/
    search_fields = ['question_text']

    # sets order of form fields on admin panel for http://localhost:8000/admin/polls/question/:id/change/
    fieldsets = [
        ('Question', {'fields': ['question_text']}),
        ('Date information', {'fields': [
         'pub_date'], 'classes': ['collapse']}),
    ]
    inlines = [ChoiceInline]


admin.site.register(Question, QuestionAdmin)
