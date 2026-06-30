db.feedback.insertMany([
  {
    student_id: 1,
    course_code: 'CS101',
    semester: '2027-ODD',
    rating: 5,
    comments: 'Excellent teaching. Highly recommended!',
    tags: ['well-structured', 'good-examples'],
    submitted_at: ISODate('2027-11-20T10:15:00Z'),
    attachments: [{ filename: 'dbms_notes.pdf', size_kb: 450 }]
  },
  {
    student_id: 2,
    course_code: 'CS101',
    semester: '2027-ODD',
    rating: 4,
    comments: 'Good lectures but assignments are heavy.',
    tags: ['challenging', 'good-examples'],
    submitted_at: ISODate('2027-11-22T14:30:00Z'),
    attachments: [{ filename: 'assignment1.zip', size_kb: 1200 }]
  },
  {
    student_id: 3,
    course_code: 'CS101',
    semester: '2027-ODD',
    rating: 3,
    comments: 'Average explanation pace.',
    tags: ['challenging'],
    submitted_at: ISODate('2027-11-25T09:00:00Z'),
    attachments: []
  },
  {
    student_id: 4,
    course_code: 'CS102',
    semester: '2027-ODD',
    rating: 5,
    comments: 'Amazing practical insights for this course.',
    tags: ['well-structured', 'interactive'],
    submitted_at: ISODate('2027-11-26T11:45:00Z'),
    attachments: [{ filename: 'syllabus.pdf', size_kb: 180 }]
  },
  {
    student_id: 5,
    course_code: 'CS102',
    semester: '2027-EVEN',
    rating: 2,
    comments: 'Expected more live coding sessions.',
    tags: ['slow-paced'],
    submitted_at: ISODate('2027-04-12T16:20:00Z'),
    attachments: [{ filename: 'lab_manual.pdf', size_kb: 890 }]
  },
  {
    student_id: 1,
    course_code: 'CS203',
    semester: '2027-EVEN',
    rating: 4,
    comments: 'Very interesting concepts covered.',
    tags: ['well-structured'],
    submitted_at: ISODate('2027-04-15T10:00:00Z'),
    attachments: []
  },
  {
    student_id: 2,
    course_code: 'CS304',
    semester: '2027-ODD',
    rating: 5,
    comments: 'Professor handles doubts perfectly.',
    tags: ['good-examples', 'interactive'],
    submitted_at: ISODate('2027-11-28T15:10:00Z'),
    attachments: [{ filename: 'project_guidelines.pdf', size_kb: 310 }]
  },
  {
    student_id: 3,
    course_code: 'CS405',
    semester: '2027-EVEN',
    rating: 1,
    comments: 'Course load is way too high.',
    tags: ['challenging', 'heavy-load'],
    submitted_at: ISODate('2027-04-18T08:40:00Z'),
    attachments: [{ filename: 'slides.pptx', size_kb: 4500 }]
  },
  {
    student_id: 4,
    course_code: 'CS208',
    semester: '2027-ODD',
    rating: 4,
    comments: 'Clear audio and neat explanations.',
    tags: ['well-structured'],
    submitted_at: ISODate('2027-11-29T12:05:00Z'),
    attachments: [{ filename: 'notes_v2.pdf', size_kb: 240 }]
  },
  {
    // 63. Intentionally OMITTING the attachments array field entirely
    student_id: 5,
    course_code: 'CS309',
    semester: '2027-ODD',
    rating: 4,
    comments: 'Great intro sessions.',
    tags: ['beginner-friendly'],
    submitted_at: ISODate('2027-11-30T10:00:00Z')
  }
]);
db.feedback.countDocuments()

db.feedback.find({ attachments: { $exists: false } })
// task2
db.feedback.find({ rating: 5 });
db.feedback.find({ 
  course_code: 'CS101', 
  tags: 'challenging' 
});
db.feedback.find(
  {}, 
  { student_id: 1, course_code: 1, rating: 1, _id: 0 }
);
db.feedback.updateMany(
  { rating: { $lt: 3 } },
  { $set: { needs_review: true } }
);
db.feedback.updateMany(
  { needs_review: true },
  { $push: { tags: 'reviewed' } }
);
db.feedback.deleteMany({ semester: '2021-EVEN' });